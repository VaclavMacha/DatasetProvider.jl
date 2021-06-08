module DatasetProvider

using BSON
using CSV
using CodecZlib
using DataDeps
using DataFrames
using Dates
using InteractiveUtils
using Mmap
using Random
using Statistics
using StatsBase

import MLDatasets

export load, remove, removeall, listdatasets
export Dataset
export Name
export Task, TwoClass, MultiClass
export Format, TabularData, GreyImages, ColorImages
export Split, TrainTest, TrainValidTest

# Types



# Includes
include("dataset.jl")
include("utilities.jl")
include("postprocessing.jl")

include.(readdir(joinpath(@__DIR__, "formats"); join = true))
include.(readdir(joinpath(@__DIR__, "problems"); join = true))
include.(readdir(joinpath(@__DIR__, "splits"); join = true))

include.(readdir(joinpath(@__DIR__, "datasets", "twoclass"); join = true))
include.(readdir(joinpath(@__DIR__, "datasets", "multiclass"); join = true))

# Dataset registration
function description(N::Type{<:Name})
    return """
    Dataset: $(name(N))
    Author(s): $(join(author(N), ", "))
    Website: $(source(N))
    Licence: $(licence(N))
    Sample size: $(join(nattributes(N), "x"))
    Train/validation/test: $(join(ninstances(N), "/"))

    Please respect copyright and use data responsibly. For more details about copyright and license, visit the website mentioned above.
    """
end

function make_datadep(N::Type{<:Name})
    return DataDep(
        datadepname(N),
        description(N),
        downloadlink(N),
        checksum(N);
        post_fetch_method = preprocess(N),
    )
end

const DATASETS = Ref{Vector{DataType}}(DataType[])
const PROBLEMS = Ref{Vector{DataType}}(DataType[])
const FORMATS = Ref{Vector{DataType}}(DataType[])

function updatesubtypes!()
    DATASETS[] = concretesubtypes(Name)
    PROBLEMS[] = concretesubtypes(Task)
    FORMATS[] = concretesubtypes(Format)
    return
end

name_subtypes() = DATASETS[]
problem_subtypes() = PROBLEMS[]
format_subtypes() = FORMATS[]

function __init__()
    updatesubtypes!()

    for N in name_subtypes()
        dep = make_datadep(N)
        isnothing(dep) || register(dep)
    end
end

end # module
