struct FashionMNIST <: Name end

# download options
task(::Type{FashionMNIST}) = MultiClass
format(::Type{FashionMNIST}) = GrayImages
source(::Type{FashionMNIST}) = "https://github.com/zalandoresearch/fashion-FashionMNIST"
make_datadep(::Type{FashionMNIST}) = nothing
loadraw(::Type{FashionMNIST}, type) = loadraw_mldatasets(MLDatasets.FashionMNIST, type)

nclasses(::Type{FashionMNIST}) = 10
classes(::Type{FashionMNIST}) = collect(0:9)
classes_orig(::Type{FashionMNIST}) = [ "T-Shirt", "Trouser", "Pullover", "Dress", "Coat", "Sandal", "Shirt", "Sneaker", "Bag", "Ankle boot"]
nattributes(::Type{FashionMNIST}) = (28, 28)
ninstances(::Type{FashionMNIST}) = (60000, 0, 10000)

# dataset description
name(::Type{FashionMNIST}) = "Fashion-MNIST"
author(::Type{FashionMNIST}) = ["Han Xiao", "Kashif Rasul", "Roland Vollgraf"]
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
