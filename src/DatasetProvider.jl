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

# Dataset
abstract type Name end
abstract type Problem end

postprocess(::Problem, data) = data

abstract type Format end

saveformat(::Type{<:Format}) = "bson"
save_raw(::Type{<:Format}, path, data) = BSON.bson(path, data)

function load_raw(::Type{<:Format}, path)
    dict = BSON.bson(path)
    return dict[:data], dict[:targets]
end

postprocess(::Format, data) = data

struct Dataset{N<:Name, P<:Problem, F<:Format}
    problem::P
    format::F
    shuffle::Bool
    seed::Int64

    function Dataset(
        N::Type{<:Name},
        problem::P,
        format::F;
        shuffle::Bool = false,
        seed::Int64 = 1234,
        kwargs...
    ) where {P<:Problem, F<:Format}

        return new{N, P, F}(problem, format, shuffle, seed)
    end
end

function Dataset(N::Type{<:Name}; kwargs...)
    Dataset(N, problem(N; kwargs...), format(N; kwargs...); kwargs...)
end

function Base.show(io::IO, ::Dataset{N, P, F}) where {N<:Name, P<:Problem, F<:Format}
    println(io, "Dataset: ", nameof(N))
    println(io, " - ", nameof(P), " problem")
    println(io, " - ", nameof(F), " format")
    return
end

function postprocess(dataset::Dataset, data)
    data = postprocess(dataset.format, data)
    data = postprocess(dataset.problem, data)
    return copy.(data)
end

# Name
function hassubset(N::Type{<:Name}, type::Symbol)
    return if type == :train
        hastrain(N)
    elseif type == :valid
        hasvalid(N)
    elseif type == :test
        hastest(N)
    else
        false
    end
end

hastrain(::Type{<:Name}) = true
hasvalid(::Type{<:Name}) = false
hastest(::Type{<:Name}) = false

function problemtype() end
function formattype() end

problem(N::Type{<:Name}; kwargs...) = problemtype(N)(; kwargs...)
format(N::Type{<:Name}; kwargs...) = formattype(N)(; kwargs...)

# Includes
include("saveload.jl")
include("problems.jl")
include("formats.jl")
include("utilities.jl")
include("postprocessing.jl")
include("splits.jl")

function __init__()
    include.(readdir(joinpath(@__DIR__, "datasets", "uci"); join = true))
    include(joinpath(@__DIR__, "datasets", "mldatasets.jl"))
end

end # module
