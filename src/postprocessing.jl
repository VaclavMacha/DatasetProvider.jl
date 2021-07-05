# data splitting
function data_split(d::Dataset, data::Tuple, obsdim, at)
    x, y = data
    return map(partition(d, y, at)) do inds
        return selectdim(x, obsdim, inds), selectdim(y, 1, inds)
    end
end

function data_split(d::Dataset, data::AbstractDataFrame, obsdim, at)
    y = data.targets |> Vector
    return map(partition(d, y, at)) do inds
        return data[inds, :]
    end
end

# data shuffle
function data_shuffle(data, obsdim, flag::Bool; seed = 1234)
    return flag ? data_shuffle(data, obsdim; seed) : data
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
    insertcols!(data, 1, :targets => data_binarize(y, poslabels))
    return data
end

data_binarize(y::AbstractVector, poslabels::AbstractString) = y .== poslabels
data_binarize(y::AbstractVector, poslabels::Symbol) = y .== poslabels
data_binarize(y::AbstractVector, poslabels) = in.(y, Ref(poslabels))


function data_binarize_regression(data::Tuple, threshold::Real)
    x, y = data
    return x, y .>= threshold
end

function data_binarize_regression(data::AbstractDataFrame, threshold::Real)
    y = data.targets
    select!(data, Not(:targets))
    insertcols!(data, 1, :targets => y .>= threshold)
    return data
end