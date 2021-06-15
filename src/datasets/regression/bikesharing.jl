abstract type AbstractBikeSharing <: Name end
struct BikeSharingHour <: AbstractBikeSharing end
struct BikeSharingDay <: AbstractBikeSharing end

# mandatory methods
format(::Type{<:AbstractBikeSharing}) = TabularData
task(::Type{<:AbstractBikeSharing}) = Regression
source(::Type{<:AbstractBikeSharing}) = "https://archive.ics.uci.edu/ml/datasets/bike+sharing+dataset"

function downloadlink(N::Type{<:AbstractBikeSharing})
    return "https://archive.ics.uci.edu/ml/machine-learning-databases/00275/Bike-Sharing-Dataset.zip"
end



function preprocess(N::Type{BikeSharingHour})
    istarget = 17
    iscategorical = vcat(3:10, 15:16)
    toremove = 1

    return function (path)
        unzip(path; skip = f -> f.name in ["day.csv", "Readme.txt"])
        file = joinpath(datadir(N), "hour.csv")
        preprocess_csv(N, file, :train; istarget, iscategorical, toremove, header = true)
        return 
    end
end

function preprocess(N::Type{BikeSharingDay})
    istarget = 16
    iscategorical = vcat(3:9, 14:15)
    toremove = 1

    return function (path)
        unzip(path; skip = f -> f.name in ["hour.csv", "Readme.txt"])
        file = joinpath(datadir(N), "day.csv")
        preprocess_csv(N, file, :train; istarget, iscategorical, toremove, header = true)
        return 
    end
end

nattributes(::Type{BikeSharingHour}) = (16, )
nattributes(::Type{BikeSharingDay}) = (15, )
ninstances(::Type{BikeSharingHour}) = (17389, 0, 0)
ninstances(::Type{BikeSharingDay}) = (731, 0, 0)

# optional methods
function checksum(::Type{<:AbstractBikeSharing})
    return "b70182d0d0508e9abbb79306ce5c0cec34869000f8220175ac83d11dbe845401"
end

name(::Type{<:AbstractBikeSharing}) = "AbstractBikeSharing Compressive Strength Data Set"
author(::Type{<:AbstractBikeSharing}) = ["Hadi Fanaee-T", "Joao Gama"]

function citation(::Type{<:AbstractBikeSharing})
    return """
    @article{
        year={2013},
        issn={2192-6352},
        journal={Progress in Artificial Intelligence},
        doi={10.1007/s13748-013-0040-3},
        title={Event labeling combining ensemble detectors and background knowledge},
        url={[Web Link]},
        publisher={Springer Berlin Heidelberg},
        keywords={Event labeling; Event detection; Ensemble learning; Background knowledge},
        author={Fanaee-T, Hadi and Gama, Joao},
        pages={1-15}
    }
    """
end