struct TrainTest <: Split
    at::Float64

    TrainTest(at::Real = 0.75) = new(at)
end

function load(
    split::TrainTest,
    dataset::Dataset{N, F, T}
) where {N<:Name, F<:Format, T<:Task}

    train = load(dataset, :train; dopostprocess = false)
    if !hassubset(N, :test)
        train, test = data_split(dataset, train, samplesdim(F), split.at)
    else
        test = load(dataset, :test; dopostprocess = false)
    end

    train = postprocess(dataset, train)
    test = postprocess(dataset, test)

    return train, test
end
