struct Ionosphere{F, T} <: Name{F, T}
    Ionosphere() = new{TabularData, TwoClass}()
end

# mandatory methods
nattributes(::Ionosphere) = (34, )
ninstances(::Ionosphere) = (351, 0, 0)
source(::Ionosphere) = "http://archive.ics.uci.edu/ml/datasets/Ionosphere"
checksum(::Ionosphere) = "46d52186b84e20be52918adb93e8fb9926b34795ff7504c24350ae0616a04bbd"

function downloadlink(::Ionosphere)
    return "https://archive.ics.uci.edu/ml/machine-learning-databases/ionosphere/ionosphere.data"
end

function preprocess(N::Ionosphere)
    return path -> csv_data(N, path, :train; col_targets = 35, pos_labels = "b")
end

# optional methods
name(::Ionosphere) = "Johns Hopkins University Ionosphere database"
author(::Ionosphere) = ["Vince Sigillito"]

function citation(::Ionosphere)
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
