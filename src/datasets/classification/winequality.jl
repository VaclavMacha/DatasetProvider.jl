abstract type AbstractWineQuality <: Name end

struct RedWineQuality <: AbstractWineQuality end
struct WhiteWineQuality <: AbstractWineQuality end

# mandatory methods
format(::Type{<:AbstractWineQuality}) = TabularData
task(::Type{<:AbstractWineQuality}) = MultiClass
source(::Type{<:AbstractWineQuality}) = "https://archive.ics.uci.edu/ml/datasets/wine+quality"

function downloadlink(::Type{RedWineQuality})
    return "https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv"
end

function downloadlink(::Type{WhiteWineQuality})
    return "https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-white.csv"
end

function preprocess(N::Type{<:AbstractWineQuality})
    return path -> preprocess_csv(N, path, :train; istarget = 12, header = true)
end

nclasses(::Type{RedWineQuality}) = 6
nclasses(::Type{WhiteWineQuality}) = 7
classes(::Type{RedWineQuality}) = collect(3:8)
classes(::Type{WhiteWineQuality}) = collect(3:9)
classes_orig(::Type{RedWineQuality}) = collect(3:8)
classes_orig(::Type{WhiteWineQuality}) = collect(3:9)
nattributes(::Type{<:AbstractWineQuality}) = (11, )
ninstances(::Type{RedWineQuality}) = (1599, 0, 0)
ninstances(::Type{WhiteWineQuality}) = (4898, 0, 0)

# optional methods
function checksum(::Type{RedWineQuality})
    return "4a402cf041b025d4566d954c3b9ba8635a3a8a01e039005d97d6a710278cf05e"
end
function checksum(::Type{WhiteWineQuality})
    return "76c3f809815c17c07212622f776311faeb31e87610d52c26d87d6e361b169836"
end

name(::Type{<:AbstractWineQuality}) = "Wine Quality Data Set"
author(::Type{<:AbstractWineQuality}) = ["Paulo Cortez", "A. Cerdeira", "F. Almeida", "T. Matos", "J. Reis"]

function citation(::Type{<:AbstractWineQuality})
    return """
    @article{cortez2009modeling,
        title={Modeling wine preferences by data mining from physicochemical properties},
        author={Cortez, Paulo and Cerdeira, Ant{\'o}nio and Almeida, Fernando and Matos, Telmo and Reis, Jos{\'e}},
        journal={Decision support systems},
        volume={47},
        number={4},
        pages={547--553},
        year={2009},
        publisher={Elsevier}
    }
    """
end