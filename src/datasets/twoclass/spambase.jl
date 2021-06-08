struct Spambase <: Name end

# mandatory methods
problem(::Type{Spambase}) = TwoClass
format(::Type{Spambase}) = TabularData
nattributes(::Type{Spambase}) = (57,)
ninstances(::Type{Spambase}) = (4601, 0, 0)

function source(::Type{Spambase})
    return "http://archive.ics.uci.edu/ml/datasets/spambase"
end

function downloadlink(::Type{Spambase})
    return "https://archive.ics.uci.edu/ml/machine-learning-databases/spambase/spambase.data"
end

function preprocess(N::Type{Spambase})
    return path -> csv_data(N, path, :train; col_targets = 58, pos_labels = 1)
end

# optional methods
function checksum(::Type{Spambase})
    return "b1ef93de71f97714d3d7d4f58fc9f718da7bbc8ac8a150eff2778616a8097b12"
end

name(::Type{Spambase}) = "Spam e-mail database"

function author(::Type{Spambase})
    return ["Mark Hopkins", "Erik Reeber", "George Forman", "Jaap Suermondt"]
end
