struct CommunitiesCrime <: Name end

# mandatory methods
format(::Type{CommunitiesCrime}) = TabularData
task(::Type{CommunitiesCrime}) = Regression
source(::Type{CommunitiesCrime}) = "https://archive.ics.uci.edu/ml/datasets/communities+and+crime"

function downloadlink(::Type{CommunitiesCrime})
    return "https://archive.ics.uci.edu/ml/machine-learning-databases/communities/communities.data"
end

function preprocess(N::Type{CommunitiesCrime})
    return path -> preprocess_csv(N, path, :train; istarget = 1)
end

nattributes(::Type{CommunitiesCrime}) = (128, )
ninstances(::Type{CommunitiesCrime}) = (1994, 0, 0)

# optional methods
function checksum(::Type{CommunitiesCrime})
    return "09e0b5c07eae24c1efab19b2edee05e160e7f5743b6f31e31eec3d73624da2ea"
end

name(::Type{CommunitiesCrime}) = "Communities and Crime Data Set"
author(::Type{CommunitiesCrime}) = ["Michael Redmond"]