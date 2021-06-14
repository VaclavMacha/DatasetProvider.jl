abstract type AbstractSVHN2 <: Name end
struct SVHN2 <: AbstractSVHN2 end
struct SVHN2Extra <: AbstractSVHN2 end

# mandatory methods
format(::Type{<:AbstractSVHN2}) = ColorImages
task(::Type{<:AbstractSVHN2}) = MultiClass
source(::Type{<:AbstractSVHN2}) = "http://ufldl.stanford.edu/housenumbers"
datadepname(::Type{<:AbstractSVHN2}) = "SVHN2"
make_datadep(::Type{<:AbstractSVHN2}) = nothing

loadraw(::Type{SVHN2}, type) = loadraw_mldatasets(MLDatasets.SVHN2, type) 

function loadraw(::Type{SVHN2Extra}, type, T = Float32)
    if type == :train
        xtrain, ytrain = MLDatasets.SVHN2.traindata(T)
        xextra, yextra = MLDatasets.SVHN2.extradata(T)
        x = cat(xtrain, xextra; dims = 4)
        y = cat(ytrain, yextra; dims = 1)
    elseif type == :test
        x, y = MLDatasets.SVHN2.testdata(T)
    else
        error("$(type) dataset not provided for $(nameof(N))")
    end
    return x, y
end

nclasses(::Type{<:AbstractSVHN2}) = 10
classes(::Type{<:AbstractSVHN2}) = collect(1:10)
classes_orig(::Type{<:AbstractSVHN2}) = collect(0:9)
nattributes(::Type{<:AbstractSVHN2}) = (32, 32, 3)
ninstances(::Type{SVHN2}) = (73257, 0, 26032)
ninstances(::Type{SVHN2Extra}) = (604388, 0, 26032)


# dataset description
name(::Type{<:AbstractSVHN2}) = "The Street View House Numbers (SVHN) Dataset"

function author(::Type{<:AbstractSVHN2})
    return ["Yuval Netzer", "Tao Wang", "Adam Coates", "Alessandro Bissacco", "Bo Wu", "Andrew Y. Ng"]
end

function citation(::Type{<:AbstractSVHN2})
    return """
    @article{netzer2011reading,
        title = {Reading digits in natural images with unsupervised feature learning},
        author = {Netzer, Yuval and Wang, Tao and Coates, Adam and Bissacco, Alessandro and Wu, Bo and Ng, Andrew Y},
        year = {2011}
    }
    """
end
