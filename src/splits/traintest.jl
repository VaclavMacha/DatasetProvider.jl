function load(
    dataset::Dataset{N, P, F},
    type::Symbol;
    dopostprocess::Bool = true,
) where {N<:Name, P<:Problem, F<:Format}

    seed = dataset.seed
    shuffle = dataset.shuffle
    obsdim = samplesdim(F)
    data = data_shuffle(load_raw(N, type), obsdim, shuffle; seed)

    if dopostprocess
        return postprocess(dataset, data)
    else
        return data
    end
end

load(dataset::Dataset) = load(TrainValidTest(), dataset)

struct TrainTest <: Split
    at::Float64

    TrainTest(at::Real = 0.75) = new(at)
end

function load(
    split::TrainTest,
    dataset::Dataset{N, P, F}
) where {N<:Name, P<:Problem, F<:Format}

    train = load(dataset, :train; dopostprocess = false)
    if !hastest(N)
        train, test = data_split(train, samplesdim(F), split.at)
    else
        test = load(dataset, :test; dopostprocess = false)
    end

    train = postprocess(dataset, train)
    test = postprocess(dataset, test)

    return train, test
end
