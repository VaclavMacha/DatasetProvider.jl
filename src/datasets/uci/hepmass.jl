struct Hepmass <: Name end

Hepmass(; kwargs...) = Dataset(Hepmass; kwargs...)
problemtype(::Type{Hepmass}) = TwoClass
formattype(::Type{Hepmass}) = TabularData
hastest(::Type{Hepmass}) = true

function prepare(N::Type{Hepmass}, path, key)
    table = uciprepare(
        transcode(GzipDecompressor, Mmap.mmap(path));
        col_targets = 1,
        pos_labels = 1,
        header = true
    )
    save_raw(N, path, key, table)
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
