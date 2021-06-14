struct ProteinStructure <: Name end

# mandatory methods
format(::Type{ProteinStructure}) = TabularData
task(::Type{ProteinStructure}) = Regression
source(::Type{ProteinStructure}) = "https://archive.ics.uci.edu/ml/datasets/Physicochemical+Properties+of+Protein+Tertiary+Structure"

function downloadlink(::Type{ProteinStructure})
    return "https://archive.ics.uci.edu/ml/machine-learning-databases/00265/CASP.csv"
end

function preprocess(N::Type{ProteinStructure})
    return path -> preprocess_csv(N, path, :train; istarget = 1, header = true)
end

nattributes(::Type{ProteinStructure}) = (9, )
ninstances(::Type{ProteinStructure}) = (45730, 0, 0)

# optional methods
function checksum(::Type{ProteinStructure})
    return "4277cfcb4e91a181746cbc654f001b57951c9e6a80f4f795fdb5c807e0848f40"
end

name(::Type{ProteinStructure}) = "Physicochemical Properties of Protein Tertiary Structure"
author(::Type{ProteinStructure}) = ["Prashant Singh Rana"]