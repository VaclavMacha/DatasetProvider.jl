struct Gisette <: Name end

# download options
function source(::Type{Gisette})
    return "http://archive.ics.uci.edu/ml/datasets/gisette"
end

function downloadlink(::Type{Gisette})
    return [
        "https://archive.ics.uci.edu/ml/machine-learning-databases/gisette/GISETTE/gisette_train.data",
        "https://archive.ics.uci.edu/ml/machine-learning-databases/gisette/GISETTE/gisette_train.labels",
        "https://archive.ics.uci.edu/ml/machine-learning-databases/gisette/GISETTE/gisette_valid.data",
        "https://archive.ics.uci.edu/ml/machine-learning-databases/gisette/gisette_valid.labels"
    ]
end

function checksum(::Type{Gisette})
    return "d5a3e85f7db845564b066f01818a86b70bc2beefa2af3737abfc8a156b30a96d"
end

function fetchmethod(N::Type{Gisette})
    return [
        path -> csv_data(N, path, :train; col_remove = 5001)
        path -> csv_add_targets(N, path, :train; col_targets = 1, pos_labels = 1)
        path -> csv_data(N, path, :valid; col_remove = 5001)
        path -> csv_add_targets(N, path, :valid; col_targets = 1, pos_labels = 1)
    ]
end


# dataset description
name(::Type{Gisette}) = "Gisette"
author(::Type{Gisette}) = ["Isabelle Guyon"]
licence(::Type{Gisette}) = ""
citation(::Type{Gisette}) = ""


# data description
problemtype(::Type{Gisette}) = TwoClass
formattype(::Type{Gisette}) = TabularData
nclasses(::Type{Gisette}) = 2
nattributes(::Type{Gisette}) = (5000, )
ninstances(::Type{Gisette}) = (6000, 1000, 0)
