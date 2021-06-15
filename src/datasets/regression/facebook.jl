abstract type AbstractFacebook <: Name end
struct FacebookV1 <: AbstractFacebook end
struct FacebookV2 <: AbstractFacebook end
struct FacebookV3 <: AbstractFacebook end
struct FacebookV4 <: AbstractFacebook end
struct FacebookV5 <: AbstractFacebook end

# mandatory methods
format(::Type{<:AbstractFacebook}) = TabularData
task(::Type{<:AbstractFacebook}) = Regression
source(::Type{<:AbstractFacebook}) = "https://archive.ics.uci.edu/ml/datasets/Facebook+Comment+Volume+Dataset"

function downloadlink(::Type{<:AbstractFacebook})
    return "https://archive.ics.uci.edu/ml/machine-learning-databases/00363/Dataset.zip"
end

function preprocess(N::Type{<:AbstractFacebook})
    i = parse(Int, string(nameof(N))[end])
    istarget = 54
    iscategorical = vcat(35, 38, 39, 40:53)
    header = false
    files = [
        "Features_Variant_$(i).csv",
        "Features_TestSet.csv",
    ]

    return function (path)
        unzip(path; rename = basename, skip = f -> !in(basename(f.name), files))
        files = joinpath.(dirname(path), files)
        preprocess_csv(N, files[1], :train; istarget, iscategorical, header)
        preprocess_csv(N, files[2], :test; istarget, iscategorical, header)
        return 
    end
end

nattributes(::Type{<:AbstractFacebook}) = (54, )
ninstances(::Type{FacebookV1}) = (40949, 0, 10044)
ninstances(::Type{FacebookV2}) = (81312, 0, 10044)
ninstances(::Type{FacebookV3}) = (121098, 0, 10044)
ninstances(::Type{FacebookV4}) = (160424, 0, 10044)
ninstances(::Type{FacebookV5}) = (199030, 0, 10044)

# optional methods
function checksum(::Type{<:AbstractFacebook})
    return "f073dc6c33ee8704cd4eb05d982974debce255028a08babf6d4b0785d9ee31f8"
end

name(::Type{<:AbstractFacebook}) = "Facebook Comment Volume Dataset Data Set"
author(::Type{<:AbstractFacebook}) = ["Kamaljot Singh"]

function citation(::Type{<:AbstractFacebook})
    return """
    @inproceedings{Sing1503:Comment,
        author = 'Kamaljot Singh and Ranjeet Kaur Sandhu and Dinesh Kumar',
        title = 'Comment Volume Prediction Using Neural Networks and Decision Trees',
        booktitle = 'IEEE UKSim-AMSS 17th International Conference on Computer Modelling and
        Simulation, UKSim2015 (UKSim2015)',
        address = 'Cambridge, United Kingdom',
        days = 25,
        month = mar,
        year = 2015,
    } 
    """
end