struct Gisette <: Dataset end

function Gisette(; kwargs...)
    return TwoClass(Gisette, TabularData(; kwargs...); kwargs...)
end

problemtype(::Type{Gisette}) = TwoClass
formattype(::Type{Gisette}) = TabularData
hasvalid(::Type{Gisette}) = true


function prepare_data(::Type{Gisette}, path, key)
    table = csvread(path)
    save_raw(Gisette(), path, key, table[:, 1:end-1])
    return
end

function prepare_labels(::Type{Gisette}, path, key)
    table = load_raw(Gisette(), key)
    table.labels = csvread(path)[:, 1] .== 1
    save_raw(Gisette(), path, key, table)
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
