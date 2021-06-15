struct Gisette <: Name end

# mandatory methods
format(::Type{Gisette}) = TabularData
task(::Type{Gisette}) = TwoClass
source(::Type{Gisette}) = "http://archive.ics.uci.edu/ml/datasets/gisette"

function downloadlink(::Type{Gisette})
    return "https://archive.ics.uci.edu/ml/machine-learning-databases/gisette/" .* [
        "GISETTE/gisette_train.data",
        "GISETTE/gisette_train.labels",
        "GISETTE/gisette_valid.data",
        "gisette_valid.labels"
    ]
end

function preprocess(N::Type{Gisette})
    return [
        path -> preprocess_csv(N, path, :train; toremove = 5001)
        path -> preprocess_targets(N, path, :train)
        path -> preprocess_csv(N, path, :valid; toremove = 5001)
        path -> preprocess_targets(N, path, :valid)
    ]
end

nattributes(::Type{Gisette}) = (5000, )
ninstances(::Type{Gisette}) = (6000, 1000, 0)
positivelabel(::Type{Gisette}) = 1

# optional methods
function checksum(::Type{Gisette})
    return "d5a3e85f7db845564b066f01818a86b70bc2beefa2af3737abfc8a156b30a96d"
end

name(::Type{Gisette}) = "Gisette"
author(::Type{Gisette}) = ["Isabelle Guyon"]

function licence(::Type{Gisette})
    return """
    This data set is licensed under a Creative Commons Attribution 4.0 International (CC BY 4.0) license. This allows for the sharing and adaptation of the datasets for any purpose, provided that the appropriate credit is given.

    URL: https://creativecommons.org/licenses/by/4.0/legalcode
    """
end

function citation(::Type{Gisette})
    return """
    @misc{misc_gisette_170,
        author       = {Guyon, Isabelle, Gunn, Steve, Ben-Hur, Asa & Dror, Gideon},
        title        = {{Gisette}},
        year         = {2008},
        howpublished = {UCI Machine Learning Repository}
    }
    """
end
