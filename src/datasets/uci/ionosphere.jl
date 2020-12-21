struct Ionosphere <: Name end

Ionosphere(; kwargs...) = Dataset(Ionosphere; kwargs...)
problemtype(::Type{Ionosphere}) = TwoClass
formattype(::Type{Ionosphere}) = TabularData

function prepare(N::Type{Ionosphere}, path)
    table = csvread(path)

    labels = table[:, end] .== "g"
    table = table[:, 1:end-1]
    table.labels = labels
    save_raw(N, path, :train, table)
    return
end

register(DataDep(
    string(nameof(Ionosphere)),
    "http://archive.ics.uci.edu/ml/datasets/Ionosphere",
    "https://archive.ics.uci.edu/ml/machine-learning-databases/ionosphere/ionosphere.data",
    "46d52186b84e20be52918adb93e8fb9926b34795ff7504c24350ae0616a04bbd";
    post_fetch_method = path -> prepare(Ionosphere, path)
))
