struct Ionosphere <: Name end

# mandatory methods
format(::Type{Ionosphere}) = TabularData
task(::Type{Ionosphere}) = TwoClass
source(::Type{Ionosphere}) = "http://archive.ics.uci.edu/ml/datasets/Ionosphere"

function downloadlink(::Type{Ionosphere})
    return "https://archive.ics.uci.edu/ml/machine-learning-databases/ionosphere/ionosphere.data"
end

function preprocess(N::Type{Ionosphere})
    return path -> preprocess_csv(N, path, :train; istarget = 35)
end

nattributes(::Type{Ionosphere}) = (34, )
ninstances(::Type{Ionosphere}) = (351, 0, 0)
positivelabel(::Type{Ionosphere}) = "b"


# optional methods
function checksum(::Type{Ionosphere})
    return "46d52186b84e20be52918adb93e8fb9926b34795ff7504c24350ae0616a04bbd"
end

name(::Type{Ionosphere}) = "Johns Hopkins University Ionosphere database"
author(::Type{Ionosphere}) = ["Vince Sigillito"]

function citation(::Type{Ionosphere})
    return """
    @article{sigillito1989classification,
        title = {Classification of radar returns from the ionosphere using neural networks},
        author = {Sigillito, Vincent G and Wing, Simon P and Hutton, Larrie V and Baker, Kile B},
        journal = {Johns Hopkins APL Technical Digest},
        volume = {10},
        number = {3},
        pages = {262--266},
        year = {1989}
    }
    """
end
