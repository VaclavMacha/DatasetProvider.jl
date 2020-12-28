struct Spambase <: Name end

# download options
function source(::Type{Spambase})
    return "http://archive.ics.uci.edu/ml/datasets/spambase"
end

function downloadlink(::Type{Spambase})
    return "https://archive.ics.uci.edu/ml/machine-learning-databases/spambase/spambase.data"
end

function checksum(::Type{Spambase})
    return "b1ef93de71f97714d3d7d4f58fc9f718da7bbc8ac8a150eff2778616a8097b12"
end

function fetchmethod(N::Type{Spambase})
    return path -> csv_data(N, path, :train; col_targets = 58, pos_labels = 1)
end


# dataset description
name(::Type{Spambase}) = "Spam e-mail database"
function author(::Type{Spambase})
    return ["Mark Hopkins", "Erik Reeber", "George Forman", "Jaap Suermondt"]
end
licence(::Type{Spambase}) = ""
citation(::Type{Spambase}) = ""


# data description
problemtype(::Type{Spambase}) = TwoClass
formattype(::Type{Spambase}) = TabularData
nclasses(::Type{Spambase}) = 2
nattributes(::Type{Spambase}) = (57,)
ninstances(::Type{Spambase}) = (4601, 0, 0)
