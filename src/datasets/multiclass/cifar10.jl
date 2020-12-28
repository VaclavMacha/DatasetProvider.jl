struct CIFAR10 <: Name end

# download options
function source(::Type{CIFAR10})
    return "https://www.cs.toronto.edu/~kriz/cifar.html"
end

function downloadlink(::Type{CIFAR10})
    return "https://www.cs.toronto.edu/~kriz/cifar-10-binary.tar.gz"
end

make_datadep(::Type{CIFAR10}) = nothing

function load_raw(::Type{CIFAR10}, type)
    if type == :train
        x, y = MLDatasets.CIFAR10.traindata(Float64)
    elseif type == :test
        x, y = MLDatasets.CIFAR10.testdata(Float64)
    else
        error("$(type) dataset not provided for $(nameof(N))")
    end
    return x, y
end


# dataset description
name(::Type{CIFAR10}) = "CIFAR10"
function author(::Type{CIFAR10})
    return ["Alex Krizhevsky", "Vinod Nair", "Geoffrey Hinton"]
end
licence(::Type{CIFAR10}) = ""
function citation(::Type{CIFAR10})
    return """
    @article{krizhevsky2009learning,
        title = {Learning multiple layers of features from tiny images},
        author = {Krizhevsky, Alex and Hinton, Geoffrey and others},
        year = {2009},
        publisher = {Citeseer}
    }
    """
end

# data description
problemtype(::Type{CIFAR10}) = MultiClass
formattype(::Type{CIFAR10}) = ColorImages
nclasses(::Type{CIFAR10}) = 10
classes(::Type{CIFAR10}) = collect(0:9)
classes_orig(::Type{CIFAR10}) = collect(0:9)
nattributes(::Type{CIFAR10}) = (32, 32, 3)
ninstances(::Type{CIFAR10}) = (60000, 0, 10000)
