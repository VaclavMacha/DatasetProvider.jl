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

export load
export Dataset
export Name
export Task, TwoClass, MultiClass
export Format, TabularData, GreyImages, ColorImages
export Split, TrainTest, TrainValidTest

# Includes
include("types.jl")
include("dataset.jl")
include("utilities.jl")
include("postprocessing.jl")

include("./tasks/twoclass.jl")
include("./tasks/multiclass.jl")

include("./formats/tabulardata.jl")
include("./formats/images.jl")

include("./splits/traintest.jl")
include("./splits/trainvalidtest.jl")

include.(readdir(joinpath(@__DIR__, "datasets", "twoclass"); join = true))
include.(readdir(joinpath(@__DIR__, "datasets", "multiclass"); join = true))

# constants
function subtypes_list(T)
    types = DataType[]
    for Ti in subtypes(T)
        if isconcretetype(Ti)
            push!(types, Ti)
        else
            push!(types, subtypes_list(Ti)...)
        end
    end
    return types
end

const DATASETS = Ref{Vector{DataType}}(DataType[])
const TASKS = Ref{Vector{DataType}}(DataType[])
const FORMATS = Ref{Vector{DataType}}(DataType[])

name_subtypes() = DATASETS[]
problem_subtypes() = TASKS[]
format_subtypes() = FORMATS[]

function __init__()
    DATASETS[] = subtypes_list(Name)
    TASKS[] = subtypes_list(Task)
    FORMATS[] = subtypes_list(Format)

    for N in name_subtypes()
        dep = make_datadep(N)
        isnothing(dep) || register(dep)
    end
end

end # module
