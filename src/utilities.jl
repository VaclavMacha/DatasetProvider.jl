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
    Ns = concretesubtypes(Name)
    Ps = subtypes(Problem)
    Fs = subtypes(Format)

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

# split by classes
split_size(targets, at) = split_size(targets, [at...,])

function split_size(targets, at::AbstractVector)
    n = StatsBase.counts(targets)
    ns = round.(Int, n .* at')
    return [ns n .- sum(ns, dims = 2)]
end

function targets_map(targets)
    classes = sort!(unique(targets))
    mapping = Dict(tuple.(classes, 1:length(classes)))
    return y -> mapping[y]
end

targets_map(::BitArray) = y -> y ? 2 : 1

function partition_class(targets, at)
    ymap = targets_map(targets)
    ns = split_size(targets, at)

    parts = zeros.(Int, sum(ns; dims = 1))
    class_part = ones(Int, size(ns, 1))
    class_count = zero(class_part)
    pos_part = ones(Int, size(ns, 2))

    for (ind, y) in pairs(targets)
        class = ymap(y)

        count_max = ns[class, class_part[class]]
        if class_count[class] == count_max
            class_count[class] = 1
            class_part[class] += 1
        else
            class_count[class] += 1
        end

        i = class_part[class]
        parts[i][pos_part[i]] = ind
        pos_part[i] += 1
    end
    return Tuple(parts)
end

# data split
function datasplit(data::Tuple, obsdim, at)
    x, y = data
    return map(partition_class(y, at)) do inds
        return selectdim(x, obsdim, inds), selectdim(y, 1, inds)
    end
end

function datasplit(data::DataFrame, obsdim, at)
    return map(partition_class(data.labels, at)) do inds
        return view(data, inds, :)
    end
end
