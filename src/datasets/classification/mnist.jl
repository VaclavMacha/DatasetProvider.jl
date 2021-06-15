struct MNIST <: Name end

# download options
task(::Type{MNIST}) = MultiClass
format(::Type{MNIST}) = GrayImages
source(::Type{MNIST}) = "http://yann.lecun.com/exdb/mnist/"
make_datadep(::Type{MNIST}) = nothing
loadraw(::Type{MNIST}, type) = loadraw_mldatasets(MLDatasets.MNIST, type)

nclasses(::Type{MNIST}) = 10
classes(::Type{MNIST}) = collect(0:9)
classes_orig(::Type{MNIST}) = collect(0:9)
nattributes(::Type{MNIST}) = (28, 28)
ninstances(::Type{MNIST}) = (60000, 0, 10000)

# dataset description
name(::Type{MNIST}) = "The MNIST database of handwritten digits"
function author(::Type{MNIST})
    return ["Yann LeCun", "Corinna Cortes", "Christopher J.C. Burges"]
end

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
