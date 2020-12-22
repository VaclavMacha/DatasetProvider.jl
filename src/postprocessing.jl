# partition by classes
partition_size(targets, at) = partition_size(targets, [at...,])

function partition_size(targets, at::AbstractVector)
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
    ns = partition_size(targets, at)

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

# data splitting
function data_split(data::Tuple, obsdim, at)
    x, y = data
    return map(partition_class(y, at)) do inds
        return selectdim(x, obsdim, inds), selectdim(y, 1, inds)
    end
end

function data_split(data::AbstractDataFrame, obsdim, at)
    y = data.targets
    return map(partition_class(y, at)) do inds
        return view(data, inds, :)
    end
end

# data shuffle
function data_shuffle(data, onsdim, flag::Bool; seed = 1234)
    return flag ? data_shuffle(data, onsdim; seed) : data
end

function data_shuffle(data::Tuple, obsdim; seed = 1234)
    Random.seed!(seed)
    x, y = data
    prm = Random.randperm(length(y))
    return selectdim(x, obsdim, prm), selectdim(y, 1, prm)
end

function data_shuffle(data::AbstractDataFrame, obsdim; seed = 1234)
    Random.seed!(seed)
    y = data.targets
    prm = Random.randperm(length(y))
    return view(data, prm, :)
end

# binarization
data_binarize(data, poslabels, flag::Bool) = flag ? data_binarize(data, poslabels) : data

function data_binarize(data::Tuple, poslabels)
    x, y = data
    return x, data_binarize(y, poslabels)
end

function data_binarize(data::AbstractDataFrame, poslabels)
    y = data.targets
    select!(data, Not(:targets))
    data.targets = data_binarize(y, poslabels)
    return data
end

data_binarize(y::AbstractVector, poslabels::String) = y .== poslabels
data_binarize(y::AbstractVector, poslabels::Symbol) = y .== poslabels
data_binarize(y::AbstractVector, poslabels) = in.(y, Ref(poslabels))
