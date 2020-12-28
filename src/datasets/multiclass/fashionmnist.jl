struct FashionMNIST <: Name end

# download options
function source(::Type{FashionMNIST})
    return "https://github.com/zalandoresearch/fashion-FashionMNIST"
end

function downloadlink(::Type{FashionMNIST})
    return [
        "http://fashion-mnist.s3-website.eu-central-1.amazonaws.com/train-images-idx3-ubyte.gz",
        "http://fashion-mnist.s3-website.eu-central-1.amazonaws.com/train-labels-idx1-ubyte.gz",
        "http://fashion-mnist.s3-website.eu-central-1.amazonaws.com/t10k-images-idx3-ubyte.gz",
        "http://fashion-mnist.s3-website.eu-central-1.amazonaws.com/t10k-labels-idx1-ubyte.gz",
    ]
end

make_datadep(::Type{FashionMNIST}) = nothing

function load_raw(::Type{FashionMNIST}, type)
    if type == :train
        x, y = MLDatasets.FashionMNIST.traindata(Float64)
    elseif type == :test
        x, y = MLDatasets.FashionMNIST.testdata(Float64)
    else
        error("$(type) dataset not provided for $(nameof(N))")
    end
    return x, y
end

# dataset description
name(::Type{FashionMNIST}) = "Fashion-MNIST"
function author(::Type{FashionMNIST})
    return ["Han Xiao", "Kashif Rasul", "Roland Vollgraf"]
end
licence(::Type{FashionMNIST}) = "MIT"
function citation(::Type{FashionMNIST})
    return """
    @article{xiao2017fashion,
        title = {Fashion-mnist: a novel image dataset for benchmarking machine learning algorithms},
        author = {Xiao, Han and Rasul, Kashif and Vollgraf, Roland},
        journal = {arXiv preprint arXiv:1708.07747},
        year = {2017}
    }
    """
end

# data description
problemtype(::Type{FashionMNIST}) = MultiClass
formattype(::Type{FashionMNIST}) = GrayImages
nclasses(::Type{FashionMNIST}) = 10
classes(::Type{FashionMNIST}) = collect(0:9)
classes_orig(::Type{FashionMNIST}) = [ "T-Shirt", "Trouser", "Pullover", "Dress", "Coat", "Sandal", "Shirt", "Sneaker", "Bag", "Ankle boot"]
nattributes(::Type{FashionMNIST}) = (28, 28)
ninstances(::Type{FashionMNIST}) = (60000, 0, 10000)
