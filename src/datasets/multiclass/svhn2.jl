struct SVHN2 <: Name end

# download options
function source(::Type{SVHN2})
    return "http://ufldl.stanford.edu/housenumbers"
end

function downloadlink(::Type{SVHN2})
    return [
        "http://ufldl.stanford.edu/housenumbers/train_32x32.mat",
        "http://ufldl.stanford.edu/housenumbers/test_32x32.mat",
    ]
end

make_datadep(::Type{SVHN2}) = nothing

function load_raw(::Type{SVHN2}, type)
    if type == :train
        x, y = MLDatasets.SVHN2.traindata(Float64)
    elseif type == :test
        x, y = MLDatasets.SVHN2.testdata(Float64)
    else
        error("$(type) dataset not provided for $(nameof(N))")
    end
    return x, y
end


# dataset description
name(::Type{SVHN2}) = "The Street View House Numbers (SVHN) Dataset"
function author(::Type{SVHN2})
    return ["Yuval Netzer", "Tao Wang", "Adam Coates", "Alessandro Bissacco", "Bo Wu", "Andrew Y. Ng"]
end
licence(::Type{SVHN2}) = ""
function citation(::Type{SVHN2})
    return """
    @article{netzer2011reading,
        title = {Reading digits in natural images with unsupervised feature learning},
        author = {Netzer, Yuval and Wang, Tao and Coates, Adam and Bissacco, Alessandro and Wu, Bo and Ng, Andrew Y},
        year = {2011}
    }
    """
end

# data description
problemtype(::Type{SVHN2}) = MultiClass
formattype(::Type{SVHN2}) = GrayImages
nclasses(::Type{SVHN2}) = 10
classes(::Type{SVHN2}) = collect(1:10)
classes_orig(::Type{SVHN2}) = collect(0:9)
nattributes(::Type{SVHN2}) = (32, 32, 3)
ninstances(::Type{SVHN2}) = (73257, 0, 26032)
