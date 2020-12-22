struct Gisette <: Name end

Gisette(; kwargs...) = Dataset(Gisette; kwargs...)
problemtype(::Type{Gisette}) = TwoClass
formattype(::Type{Gisette}) = TabularData
hasvalid(::Type{Gisette}) = true

function prepare_data(N::Type{Gisette}, path, key)
    table = uciprepare(
        path;
        col_remove = 5001,
    )
    save_raw(N, path, key, table)
    return
end

function prepare_labels(N::Type{Gisette}, path, key)
    table = load_raw(N, key)
    table.targets = csvread(path)[:, 1] .== 1
    save_raw(N, path, key, table)
    return
end

register(DataDep(
    string(nameof(Gisette)),
    "http://archive.ics.uci.edu/ml/datasets/gisette",
     [
        "https://archive.ics.uci.edu/ml/machine-learning-databases/gisette/GISETTE/gisette_train.data",
        "https://archive.ics.uci.edu/ml/machine-learning-databases/gisette/GISETTE/gisette_train.labels",
        "https://archive.ics.uci.edu/ml/machine-learning-databases/gisette/GISETTE/gisette_valid.data",
        "https://archive.ics.uci.edu/ml/machine-learning-databases/gisette/gisette_valid.labels"
    ],
    "d5a3e85f7db845564b066f01818a86b70bc2beefa2af3737abfc8a156b30a96d";
    post_fetch_method = [
        path -> prepare_data(Gisette, path, :train),
        path -> prepare_labels(Gisette, path, :train),
        path -> prepare_data(Gisette, path, :valid),
        path -> prepare_labels(Gisette, path, :valid),
    ]
))
