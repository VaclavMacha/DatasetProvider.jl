struct HEPMASS <: Name end

# download options
function source(::Type{HEPMASS})
    return "https://archive.ics.uci.edu/ml/datasets/HEPMASS"
end

function downloadlink(::Type{HEPMASS})
    return [
        "https://archive.ics.uci.edu/ml/machine-learning-databases/00347/all_train.csv.gz",
        "https://archive.ics.uci.edu/ml/machine-learning-databases/00347/all_test.csv.gz"
    ]
end

function checksum(::Type{HEPMASS})
    return "becdb27c603c40ba3a746736a224535585b8c19f8d02db7da28d0fc78726c52b"
end

function fetchmethod(N::Type{HEPMASS})
    return [
        path -> csv_data(N, transcode(GzipDecompressor, Mmap.mmap(path)), :train; col_targets = 1, pos_labels = 1, header = true),
        path -> csv_data(N, transcode(GzipDecompressor, Mmap.mmap(path)), :test; col_targets = 1, pos_labels = 1, header = true),
    ]
end


# dataset description
name(::Type{HEPMASS}) = "HEPMASS"
function author(::Type{HEPMASS})
    return ["Daniel Whiteson"]
end
licence(::Type{HEPMASS}) = ""
citation(::Type{HEPMASS}) = ""


# data description
problemtype(::Type{HEPMASS}) = TwoClass
formattype(::Type{HEPMASS}) = TabularData
nclasses(::Type{HEPMASS}) = 2
nattributes(::Type{HEPMASS}) = (28, )
ninstances(::Type{HEPMASS}) = (7000000, 0, 3500000)
