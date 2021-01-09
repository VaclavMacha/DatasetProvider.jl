struct CIFAR100 <: Name end

# download options
function source(::Type{CIFAR100})
    return "https://www.cs.toronto.edu/~kriz/cifar.html"
end

function downloadlink(::Type{CIFAR100})
    return "https://www.cs.toronto.edu/~kriz/cifar-100-binary.tar.gz"
end

make_datadep(::Type{CIFAR100}) = nothing

function load_raw(::Type{CIFAR100}, type)
    if type == :train
        x, ~, y = MLDatasets.CIFAR100.traindata(Float64)
    elseif type == :test
        x, ~, y = MLDatasets.CIFAR100.testdata(Float64)
    else
        error("$(type) dataset not provided for $(nameof(N))")
    end
    return x, y
end


# dataset description
name(::Type{CIFAR100}) = "CIFAR100"
function author(::Type{CIFAR100})
    return ["Alex Krizhevsky", "Vinod Nair", "Geoffrey Hinton"]
end
licence(::Type{CIFAR100}) = ""
function citation(::Type{CIFAR100})
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
problemtype(::Type{CIFAR100}) = MultiClass
formattype(::Type{CIFAR100}) = ColorImages
nclasses(::Type{CIFAR100}) = 100
classes(::Type{CIFAR100}) = collect(0:99)
classes_orig(::Type{CIFAR100}) = collect(0:99)
nattributes(::Type{CIFAR100}) = (32, 32, 3)
ninstances(::Type{CIFAR100}) = (60000, 0, 10000)
