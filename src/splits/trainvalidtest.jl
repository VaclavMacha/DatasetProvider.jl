struct TrainValidTest <: Split
    at::NTuple{2, Float64}

    TrainValidTest(at::NTuple{2, Real} = (0.5, 0.25)) = new(at)
end

function load(
    split::TrainValidTest,
    dataset::Dataset{N, F, T},
) where {N<:Name, F<:Format, T<:Task}

    at = split.at
    train = load(dataset, :train; dopostprocess = false)
    obsdim = samplesdim(F)

    if !hassubset(N, :valid) && !hassubset(N, :test)
        train, valid, test = data_split(dataset, train, obsdim, at)
    elseif !hassubset(N, :test)
        train, test = data_split(dataset, train, obsdim, sum(at))
        valid = load(dataset, :valid; dopostprocess = false)
    elseif !hassubset(N, :valid)
        train, valid = data_split(dataset, train, obsdim, sum(at))
        test = load(dataset, :test; dopostprocess = false)
    else
        valid = load(dataset, :valid; dopostprocess = false)
        test = load(dataset, :test; dopostprocess = false)
    end

    train = postprocess(dataset, train)
    valid = postprocess(dataset, valid)
    test = postprocess(dataset, test)

    return train, valid, test
end

load(dataset::Dataset) = load(TrainValidTest(), dataset)
