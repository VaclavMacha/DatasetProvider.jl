struct HEPMASS <: Name end

# mandatory methods
problem(::Type{HEPMASS}) = TwoClass
format(::Type{HEPMASS}) = TabularData
nattributes(::Type{HEPMASS}) = (28, )
ninstances(::Type{HEPMASS}) = (7000000, 0, 3500000)

function source(::Type{HEPMASS})
    return "https://archive.ics.uci.edu/ml/datasets/HEPMASS"
end

function downloadlink(::Type{HEPMASS})
    return "https://archive.ics.uci.edu/ml/machine-learning-databases/00347/" .* [
        "all_train.csv.gz",
        "all_test.csv.gz"
    ]
end

function preprocess(N::Type{HEPMASS})
    kwargs = (col_targets = 1, pos_labels = 1, header = true, gzip = true)
    return [
        path -> csv_data(N, path, :train; kwargs...),
        path -> csv_data(N, path, :test; kwargs...),
    ]
end

# optional methods
function checksum(::Type{HEPMASS})
    return "becdb27c603c40ba3a746736a224535585b8c19f8d02db7da28d0fc78726c52b"
end

name(::Type{HEPMASS}) = "HEPMASS"
author(::Type{HEPMASS}) = ["Daniel Whiteson"]
