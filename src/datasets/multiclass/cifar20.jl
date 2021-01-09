struct CIFAR20 <: Name end

# download options
function source(::Type{CIFAR20})
    return "https://www.cs.toronto.edu/~kriz/cifar.html"
end

function downloadlink(::Type{CIFAR20})
    return "https://www.cs.toronto.edu/~kriz/cifar-10-binary.tar.gz"
end

make_datadep(::Type{CIFAR20}) = nothing
datadepname(::Type{CIFAR20}) = "CIFAR100"

function load_raw(::Type{CIFAR20}, type)
    if type == :train
        x, y, ~ = MLDatasets.CIFAR100.traindata(Float64)
    elseif type == :test
        x, y, ~ = MLDatasets.CIFAR100.testdata(Float64)
    else
        error("$(type) dataset not provided for $(nameof(N))")
    end
    return x, y
end


# dataset description
name(::Type{CIFAR20}) = "CIFAR20"
function author(::Type{CIFAR20})
    return ["Alex Krizhevsky", "Vinod Nair", "Geoffrey Hinton"]
end
licence(::Type{CIFAR20}) = ""
function citation(::Type{CIFAR20})
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
problemtype(::Type{CIFAR20}) = MultiClass
formattype(::Type{CIFAR20}) = ColorImages
nclasses(::Type{CIFAR20}) = 10
classes(::Type{CIFAR20}) = collect(0:9)
classes_orig(::Type{CIFAR20}) = collect(0:9)
nattributes(::Type{CIFAR20}) = (32, 32, 3)
ninstances(::Type{CIFAR20}) = (60000, 0, 10000)
