struct MNIST <: Name end

# download options
function source(::Type{MNIST})
    return "http://yann.lecun.com/exdb/mnist/"
end

function downloadlink(::Type{MNIST})
    return [
         "http://yann.lecun.com/exdb/mnist/train-images-idx3-ubyte.gz",
        "http://yann.lecun.com/exdb/mnist/train-labels-idx1-ubyte.gz",
        "http://yann.lecun.com/exdb/mnist/t10k-images-idx3-ubyte.gz",
        "http://yann.lecun.com/exdb/mnist/t10k-labels-idx1-ubyte.gz",
    ]
end

make_datadep(::Type{MNIST}) = nothing

function load_raw(::Type{MNIST}, type)
    if type == :train
        x, y = MLDatasets.MNIST.traindata(Float64)
    elseif type == :test
        x, y = MLDatasets.MNIST.testdata(Float64)
    else
        error("$(type) dataset not provided for $(nameof(N))")
    end
end

# dataset description
name(::Type{MNIST}) = "The MNIST database of handwritten digits"
function author(::Type{MNIST})
    return ["Yann LeCun", "Corinna Cortes", "Christopher J.C. Burges"]
end
licence(::Type{MNIST}) = ""
function citation(::Type{MNIST})
    return """
    @article{lecun1998gradient,
        title = {Gradient-based learning applied to document recognition},
        author = {LeCun, Yann and Bottou, L{\\'e}on and Bengio, Yoshua and Haffner, Patrick},
        journal = {Proceedings of the IEEE},
        volume = {86},
        number = {11},
        pages = {2278--2324},
        year = {1998},
        publisher = {Ieee}
    }
    """
end

# data description
problemtype(::Type{MNIST}) = MultiClass
formattype(::Type{MNIST}) = GrayImages
nclasses(::Type{MNIST}) = 10
classes(::Type{MNIST}) = collect(0:9)
classes_orig(::Type{MNIST}) = collect(0:9)
nattributes(::Type{MNIST}) = (28, 28)
ninstances(::Type{MNIST}) = (60000, 0, 10000)
