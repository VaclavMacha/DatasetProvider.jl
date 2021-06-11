struct Spambase <: Name end

# mandatory methods
format(::Type{Spambase}) = TabularData
task(::Type{Spambase}) = TwoClass
source(::Type{Spambase}) = "http://archive.ics.uci.edu/ml/datasets/spambase"

function downloadlink(::Type{Spambase})
    return "https://archive.ics.uci.edu/ml/machine-learning-databases/spambase/spambase.data"
end

function preprocess(N::Type{Spambase})
    return path -> preprocess_csv(N, path, :train; istarget = 58)
end

nattributes(::Type{Spambase}) = (57, )
ninstances(::Type{Spambase}) = (4601, 0, 0)
positivelabel(::Type{Spambase}) = 1

# optional methods
function checksum(::Type{Spambase})
    return "b1ef93de71f97714d3d7d4f58fc9f718da7bbc8ac8a150eff2778616a8097b12"
end

name(::Type{Spambase}) = "Spam e-mail database"
function author(::Type{Spambase})
    return ["Mark Hopkins", "Erik Reeber", "George Forman", "Jaap Suermondt"]
end