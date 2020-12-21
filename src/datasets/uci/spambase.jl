struct Spambase <: Name end

Spambase(; kwargs...) = Dataset(Spambase; kwargs...)
problemtype(::Type{Spambase}) = TwoClass
formattype(::Type{Spambase}) = TabularData

function prepare(N::Type{Spambase}, path)
    table = csvread(path)

    labels = table[:, end] .== 1
    table = table[:, 1:end-1]
    table.labels = labels
    save_raw(N, path, :train, table)
    return
end

register(DataDep(
    string(nameof(Spambase)),
    "http://archive.ics.uci.edu/ml/datasets/spambase",
    "https://archive.ics.uci.edu/ml/machine-learning-databases/spambase/spambase.data",
    "b1ef93de71f97714d3d7d4f58fc9f718da7bbc8ac8a150eff2778616a8097b12";
    post_fetch_method = path -> prepare(Spambase, path)
))
