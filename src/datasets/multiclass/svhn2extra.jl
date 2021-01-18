struct SVHN2Extra <: Name end

# download options
function source(::Type{SVHN2Extra})
    return "http://ufldl.stanford.edu/housenumbers"
end

function downloadlink(::Type{SVHN2Extra})
    return [
        "http://ufldl.stanford.edu/housenumbers/train_32x32.mat",
        "http://ufldl.stanford.edu/housenumbers/test_32x32.mat",
        "http://ufldl.stanford.edu/housenumbers/extra_32x32.mat",
    ]
end

make_datadep(::Type{SVHN2Extra}) = nothing
datadepname(::Type{SVHN2Extra}) = "SVHN2"

function load_raw(::Type{SVHN2Extra}, type)
    if type == :train
        xtrain, ytrain = MLDatasets.SVHN2.traindata(Float64)
        xextra, yextra = MLDatasets.SVHN2.extradata(Float64)
        x = cat(xtrain, xextra; dims = 4)
        x = cat(ytrain, yextra; dims = 1)
    elseif type == :test
        x, y = MLDatasets.SVHN2.testdata(Float64)
    else
        error("$(type) dataset not provided for $(nameof(N))")
    end
    return x, y
end


# dataset description
name(::Type{SVHN2Extra}) = "The Street View House Numbers (SVHN) Dataset"
function author(::Type{SVHN2Extra})
    return ["Yuval Netzer", "Tao Wang", "Adam Coates", "Alessandro Bissacco", "Bo Wu", "Andrew Y. Ng"]
end
licence(::Type{SVHN2Extra}) = ""
function citation(::Type{SVHN2Extra})
    return """
    @article{netzer2011reading,
        title = {Reading digits in natural images with unsupervised feature learning},
        author = {Netzer, Yuval and Wang, Tao and Coates, Adam and Bissacco, Alessandro and Wu, Bo and Ng, Andrew Y},
        year = {2011}
    }
    """
end

# data description
problemtype(::Type{SVHN2Extra}) = MultiClass
formattype(::Type{SVHN2Extra}) = ColorImages
nclasses(::Type{SVHN2Extra}) = 10
classes(::Type{SVHN2Extra}) = collect(1:10)
classes_orig(::Type{SVHN2Extra}) = collect(0:9)
nattributes(::Type{SVHN2Extra}) = (32, 32, 3)
ninstances(::Type{SVHN2Extra}) = (604388, 0, 26032)
