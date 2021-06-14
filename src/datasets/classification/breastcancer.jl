struct BreastCancer <: Name end

# mandatory methods
format(::Type{BreastCancer}) = TabularData
task(::Type{BreastCancer}) = TwoClass
source(::Type{BreastCancer}) = "https://archive.ics.uci.edu/ml/datasets/Breast+Cancer"

function downloadlink(::Type{BreastCancer})
    return "https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer/breast-cancer.data"
end

function preprocess(N::Type{BreastCancer})
    return path -> preprocess_csv(N, path, :train; istarget = 1, iscategorical = 2:10)
end

nattributes(::Type{BreastCancer}) = (9, )
ninstances(::Type{BreastCancer}) = (286, 0, 0)
positivelabel(::Type{BreastCancer}) = "recurrence-events"


# optional methods
function checksum(::Type{BreastCancer})
    return "ca7d3fa97b62ff967b6894ffbb3acaaf4a51062e0149e5950b3ad6f685970b65"
end

name(::Type{BreastCancer}) = "Breast Cancer Data Set"
function author(::Type{BreastCancer})
    return ["Matjaz Zwitter", "Milan Soklic", "Ming Tan", "Jeff Schlimmer"]
end