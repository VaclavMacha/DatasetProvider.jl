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
export Problem, TwoClass, MultiClass
export Format, TabularData, GreyImages, ColorImages
export Split, TrainTest, TrainValidTest

# Name type
abstract type Name end

const symbtoint = (train = 1, valid = 2, test = 3)
hassubset(N::Type{<:Name}, type::Int) = ninstances(N)[type] > 0
hassubset(N::Type{<:Name}, type::Symbol) = hassubset(N, getproperty(symbtoint, type))

hastrain(N::Type{<:Name}) = hassubset(N, :train)
hasvalid(N::Type{<:Name}) = hassubset(N, :valid)
hastest(N::Type{<:Name}) = hassubset(N, :test)

# Problem type
abstract type Problem end

postprocess(::Problem, data) = data

# Format type
abstract type Format end

postprocess(::Format, data) = data

function Base.show(io::IO, type::T) where {T<:Union{Problem, Format}}
    vals = getfield.(Ref(type), fieldnames(T))
    vals_str = isempty(vals) ? "" : string("(", join(vals, ", "), ")")
    print(io, nameof(T), vals_str)
    return
end

# Split type
abstract type Split end

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
        string(nameof(N)),
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
    PROBLEMS[] = concretesubtypes(Problem)
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
