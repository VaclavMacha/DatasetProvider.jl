struct Hepmass <: Dataset end

function Hepmass(; kwargs...)
    return TwoClass(Gisette, TabularData(; kwargs...); kwargs...)
end

problemtype(::Type{Hepmass}) = TwoClass
formattype(::Type{Hepmass}) = TabularData
hastest(::Type{Gisette}) = true

function prepare(::Type{Hepmass}, path, key)
    table = csvread(transcode(GzipDecompressor, Mmap.mmap(path)); header = true)

    labels = table[:, 1] .== 1
    table = table[:, 2:end]
    table.labels = labels
    save_raw(Hepmass(), path, key, table)
    return
end

register(DataDep(
    string(nameof(Hepmass)),
    "https://archive.ics.uci.edu/ml/datasets/HEPMASS",
     [
        "https://archive.ics.uci.edu/ml/machine-learning-databases/00347/all_train.csv.gz",
        "https://archive.ics.uci.edu/ml/machine-learning-databases/00347/all_test.csv.gz"
    ],
    "becdb27c603c40ba3a746736a224535585b8c19f8d02db7da28d0fc78726c52b";
    post_fetch_method = [
        path -> prepare(Hepmass, path, :train),
        path -> prepare(Hepmass, path, :test),
    ]
))
