function remove(D::Type{<:Dataset})
    path = DataDeps.try_determine_load_path("$(nameof(D))", @__DIR__)
    if !isnothing(path)
        rm(path; recursive = true)
        @info "$(nameof(D)) dataset removed"
    end
    return
end

function removeall()
    remove.(concretesubtypes(Dataset))
    return
end

problemtype(::Type{<:Dataset}) = Problem
formattype(::Type{<:Dataset}) = Format

function concretesubtypes(T::Type)
    types = map(subtypes(T)) do S
        return isabstracttype(S) ? concretesubtypes(S) : S
    end
    return reduce(vcat, types)
end

function listdatasets(;
    problem::Type{<:Problem} = Problem,
    format::Type{<:Format} = Format,
)

    Ds = concretesubtypes(Dataset)
    Ps = isabstracttype(problem) ? subtypes(problem) : problem
    Fs = isabstracttype(format) ? subtypes(format) : format

    for P in Ps
        isabstracttype(P) && continue
        printstyled("$(nameof(P)): \n"; color = :blue, bold = true)
        for F in Fs
            isabstracttype(F) && continue
            datasets = [D for D in Ds if problemtype(D) <: P && formattype(D) <: F]
            isempty(datasets) && continue
            printstyled("  $(nameof(F)): \n"; color = :yellow, bold = true)
            for D in datasets
                path = DataDeps.try_determine_load_path("$(nameof(D))", @__DIR__)
                if isnothing(path)
                    printstyled("    ✖ $(nameof(D)) \n"; color = :red)
                else
                    printstyled("    ✔ $(nameof(D)) \n"; color = :green, bold = true)
                end
            end
        end
    end
    return
end

function csvread(
    path;
    header = false,
    typemap = Dict(Date => String, DateTime => String),
    missingstrings = ["", "NA", "?", "*", "#DIV/0!"],
    truestrings = ["T", "t", "TRUE", "true", "y", "yes"],
    falsestrings = ["F", "f", "FALSE", "false", "n", "no"],
    kwargs...
)
    return CSV.File(
        path;
        header,
        typemap,
        missingstrings,
        truestrings,
        falsestrings,
        kwargs...
    ) |> DataFrame
end

function datapath(::Problem{D, F}, type) where {D<:Dataset, F<:Format}
    path = @datadep_str("$(nameof(D))")
    return joinpath(path, "data_$(type).bson")
end

function datapath(::Problem{D, F}, type) where {D<:Dataset, F<:TabularData}
    path = @datadep_str("$(nameof(D))")
    return joinpath(path, "data_$(type).csv")
end

function save_raw(
    problem::Problem{D, F},
    path,
    type,
    data;
    clearpath = true
) where {D<:Dataset, F<:TabularData}

    save_raw(datapath(problem, type), data)
    clearpath && rm(path)
    return
end

function save_raw(path::AbstractString, data)
    if endswith(path, ".csv")
        return CSV.write(path, data)
    elseif endswith(path, ".bson")
        return BSON.bson(path, data)
    else
        error("unsupported file format")
    end
    return
end

function load_raw(problem::Problem{D, F}, type) where {D<:Dataset, F<:TabularData}
    path = datapath(problem, type)
    isfile(path) || error("$(type) dataset not provided for $(nameof(D))")
    return load_raw(path)
end

function load_raw(path::AbstractString)
    if endswith(path, ".csv")
        return CSV.File(path; header = true) |> DataFrame
    elseif endswith(path, ".bson")
        dict = BSON.bson(path)
        return dict[:data], dict[:labels]
    else
        error("unsupported file format")
    end
    return
end

# Data split
function splitindices(labels; kwargs...)
    outs = []
    for class in sort(unique(labels))
        out = MLDataUtils.splitobs(findall(labels .== class); kwargs...)
        push!(outs, out)
    end
    return [reduce(vcat, getindex.(outs, i)) for i in 1:length(outs[1])]
end

function stratifiedsplit(data::Tuple, obsdim; kwargs...)
    x, y = data
    return map(splitindices(y; kwargs...)) do inds
        return (Array(selectdim(x, obsdim, inds)), y[inds])
    end
end

function stratifiedsplit(data::DataFrame, obsdim; kwargs...)
    y = data.labels
    return map(splitindices(y; kwargs...)) do inds
        return data[inds, :]
    end
end

function train_valid_test(problem::Problem{D, F}) where {D<:Dataset, F<:Format}
    Random.seed!(problem.seed)

    train = load_raw(problem, :train)
    if !hasvalid(D) && !hastest(D)
        train, valid, test = stratifiedsplit(train, samplesdim(problem); at = (0.5, 0.25))
    elseif !hastest(D)
        train, test = stratifiedsplit(train, samplesdim(problem); at = 0.75)
        valid = load_raw(problem, :valid)
    elseif !hasvalid(D)
        train, valid = stratifiedsplit(train, samplesdim(problem); at = 0.75)
        test = load_raw(problem, :test)
    else
        valid = load_raw(problem, :valid)
        test = load_raw(problem, :test)
    end

    train = postprocess(problem, train)
    valid = postprocess(problem, valid)
    test = postprocess(problem, test)

    return train, valid, test
end

function train_test(problem::Problem{D, F}) where {D<:Dataset, F<:Format}
    Random.seed!(problem.seed)

    train = load_raw(problem, :train)
    if !isfile(datapath(problem, :test))
        train, test = stratifiedsplit(train, samplesdim(problem); at = 0.75)
    else
        test = load_raw(problem, :test)
    end
    return train, test
end

function postprocess(problem::TwoClass{D, F}, data) where {D<:Dataset, F<:TabularData}
    if problem.format.asmatrix
        return Array(select(data, Not(:labels))), BitArray(data.labels)
    else
        return data
    end
end

postprocess(::Problem, data) = data
