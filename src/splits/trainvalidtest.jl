struct TrainValidTest <: Split
    at::NTuple{2, Float64}

    TrainValidTest(at::NTuple{2, Real} = (0.5, 0.25)) = new(at)
end

function load(
    split::TrainValidTest,
    dataset::Dataset{N, P, F},
) where {N<:Name, P<:Problem, F<:Format}

    at = split.at
    train = load(dataset, :train; dopostprocess = false)
    obsdim = samplesdim(F)

    if !hasvalid(N) && !hastest(N)
        train, valid, test = data_split(train, obsdim, at)
    elseif !hastest(N)
        train, test = data_split(train, obsdim, sum(at))
        valid = load(dataset, :valid; dopostprocess = false)
    elseif !hasvalid(N)
        train, valid = data_split(train, obsdim, sum(at))
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
