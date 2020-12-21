abstract type Split end

struct TrainTest <: Split
    at::Float64
    standardize::Bool
    shuffle::Bool
    seed::Int64

    function TrainTest(;
        at::Real = 0.75,
        standardize = true,
        shuffle = true,
        seed = 1234,
        kwargs...
    )

        return new(at, standardize, shuffle, seed)
    end
end

function (split::TrainTest)(
    dataset::Dataset{N, P, F}
) where {N<:Name, P<:Problem, F<:Format}

    Random.seed!(split.seed)
    obsdim = samplesdim(F)
    shuffle = split.shuffle
    train = load_raw(N, :train)

    if !hastest(N)
        train, test = datasplit(train, obsdim, split.at; shuffle)
    else
        test = load_raw(N, :test)
    end
    return train, test
end

struct TrainValidTest <: Split
    at::NTuple{2, Float64}
    standardize::Bool
    shuffle::Bool
    seed::Int64

    function TrainValidTest(;
        at::NTuple{2, Real} = (0.5, 0.25),
        standardize = true,
        shuffle = true,
        seed = 1234,
        kwargs...
    )

        return new(at, standardize, shuffle, seed)
    end
end

function (split::TrainValidTest)(
    dataset::Dataset{N, P, F}
) where {N<:Name, P<:Problem, F<:Format}

    Random.seed!(split.seed)
    obsdim = samplesdim(F)
    at = split.at
    shuffle = split.shuffle
    train = load_raw(N, :train)

    if !hasvalid(N) && !hastest(N)
        train, valid, test = datasplit(train, obsdim, at; shuffle)
    elseif !hastest(N)
        train, test = datasplit(train, obsdim, sum(at); shuffle)
        valid = load_raw(N, :valid)
    elseif !hasvalid(N)
        train, valid = datasplit(train, obsdim, sum(at); shuffle)
        test = load_raw(N, :test)
    else
        valid = load_raw(N, :valid)
        test = load_raw(N, :test)
    end
    return train, valid, test
end
