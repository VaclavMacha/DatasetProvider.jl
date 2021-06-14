abstract type AbstractCIFAR <: Name end
struct CIFAR10 <: AbstractCIFAR end
struct CIFAR20 <: AbstractCIFAR end
struct CIFAR100 <: AbstractCIFAR end

# download options
task(::Type{<:AbstractCIFAR}) = MultiClass
format(::Type{<:AbstractCIFAR}) = ColorImages
source(::Type{<:AbstractCIFAR}) = "https://www.cs.toronto.edu/~kriz/cifar.html"
make_datadep(::Type{<:AbstractCIFAR}) = nothing
datadepname(::Type{CIFAR10}) = "CIFAR10"
datadepname(::Type{<:AbstractCIFAR}) = "CIFAR100"

loadraw(::Type{CIFAR10}, type) = loadraw_mldatasets(MLDatasets.CIFAR10, type)

function loadraw(::Type{CIFAR20}, type, T = Float32)
    if type == :train
        x, y, ~ = MLDatasets.CIFAR100.traindata(T)
    elseif type == :test
        x, y, ~ = MLDatasets.CIFAR100.testdata(T)
    else
        error("$(type) dataset not provided for $(nameof(N))")
    end
    return x, y
end

function loadraw(::Type{CIFAR100}, type, T = Float32)
    if type == :train
        x, ~, y = MLDatasets.CIFAR100.traindata(T)
    elseif type == :test
        x, ~, y = MLDatasets.CIFAR100.testdata(T)
    else
        error("$(type) dataset not provided for $(nameof(N))")
    end
    return x, y
end

nclasses(::Type{CIFAR10}) = 10
nclasses(::Type{CIFAR20}) = 20
nclasses(::Type{CIFAR100}) = 100
classes(::Type{CIFAR10}) = collect(0:9)
classes(::Type{CIFAR20}) = collect(0:19)
classes(::Type{CIFAR100}) = collect(0:69)
classes_orig(::Type{CIFAR10}) = collect(0:9)
classes_orig(::Type{CIFAR20}) = collect(0:19)
classes_orig(::Type{CIFAR100}) = collect(0:99)
nattributes(::Type{<:AbstractCIFAR}) = (32, 32, 3)
ninstances(::Type{<:AbstractCIFAR}) = (60000, 0, 10000)

# dataset description
name(N::Type{<:AbstractCIFAR}) = "$(nameof(N))"
author(::Type{<:AbstractCIFAR}) = ["Alex Krizhevsky", "Vinod Nair", "Geoffrey Hinton"]

function citation(::Type{<:AbstractCIFAR})
    return """
    @article{krizhevsky2009learning,
        title = {Learning multiple layers of features from tiny images},
        author = {Krizhevsky, Alex and Hinton, Geoffrey and others},
        year = {2009},
        publisher = {Citeseer}
    }
    """
end
