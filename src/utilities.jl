"""
    datapath(N::Type{<:Name}, type::Symbol)

Returns the path to the file in which the `type` subset of dataset `N` is stored and download the dataset if it not installed yet. Valid subset types are: `:train`, `:valid`, `:test`.
"""
function datapath(N::Type{<:Name}, type::Symbol)
    if !hassubset(N, type)
        throw(ArgumentError("$(type) subset not provided for $(nameof(N)) dataset"))
    end
    F = formattype(N)
    return joinpath(@datadep_str("$(nameof(N))"), "data_$(type).$(saveformat(F))")
end

function save_raw(N::Type{<:Name}, path, type, data; clearpath = true)
    save_raw(formattype(N), datapath(N, type), data)
    clearpath && rm(path)
    return
end

load_raw(N::Type{<:Name}, type) = load_raw(formattype(N), datapath(N, type))

"""
    concretesubtypes(T::Type)

Returns an array of all concrete subtypes of the given type `T`.
"""
function concretesubtypes(T::Type)
    isabstracttype(T) || return DataType[]
    types = map(subtypes(T)) do S
        return isabstracttype(S) ? concretesubtypes(S) : S
    end
    return reduce(vcat, types)
end

"""
    remove(N::Type{<:Name})

Removes given dataset `N`, if installed.
"""
function remove(N::Type{<:Name})
    path = DataDeps.try_determine_load_path("$(nameof(N))", @__DIR__)
    if !isnothing(path)
        rm(path; recursive = true)
        printstyled(" ✖ $(nameof(N)) dataset removed \n"; color = :red)
    else
        printstyled(" ✖ $(nameof(N)) dataset not installed \n"; color = :red)
    end
    return
end

"""
    removeall()

Removes all downloaded datasets.
"""
function removeall()
    if DataDeps.input_bool("Do you want to remove all downloaded datasets?")
        remove.(concretesubtypes(Name))
    end
    return
end

"""
    listdatasets()

Prints the names of all available datasets and highlights datasets that have already been downloaded. Datasets are sorted into groups based on their problem type and format type.
"""
function listdatasets()
    Ns = datasets()
    Ps = problems()
    Fs = formats()

    for P in Ps
        isabstracttype(P) && continue
        printstyled("$(nameof(P)): \n"; color = :blue, bold = true)
        for F in Fs
            isabstracttype(F) && continue
            datasets = [D for D in Ns if problemtype(D) <: P && formattype(D) <: F]
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
