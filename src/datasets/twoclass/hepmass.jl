struct HEPMASS <: Name end

# mandatory methods
format(::Type{HEPMASS}) = TabularData
task(::Type{HEPMASS}) = TwoClass
source(::Type{HEPMASS}) = "https://archive.ics.uci.edu/ml/datasets/HEPMASS"

function downloadlink(::Type{HEPMASS})
    return "https://archive.ics.uci.edu/ml/machine-learning-databases/00347/" .* [
        "all_train.csv.gz",
        "all_test.csv.gz"
    ]
end

function preprocess(N::Type{HEPMASS})
    kwargs = (istarget = 1, header = true, gzip = true)
    return [
        path -> preprocess_csv(N, path, :train; kwargs...),
        path -> preprocess_csv(N, path, :test; kwargs...),
    ]
end

nattributes(::Type{HEPMASS}) = (28, )
ninstances(::Type{HEPMASS}) = (7000000, 0, 3500000)
positivelabel(::Type{HEPMASS}) = 1

# optional methods
function checksum(::Type{HEPMASS})
    return "becdb27c603c40ba3a746736a224535585b8c19f8d02db7da28d0fc78726c52b"
end

name(::Type{HEPMASS}) = "HEPMASS"
author(::Type{HEPMASS}) = ["Daniel Whiteson"]