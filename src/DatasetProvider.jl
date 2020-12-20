module DatasetProvider

using BSON
using CSV
using CodecZlib
using DataDeps
using DataFrames
using Dates
using InteractiveUtils
using MLDataUtils
using Mmap
using Random
using Statistics

import MLDatasets

export load_raw, remove, removeall, listdatasets, train_valid_test, train_test
export Dataset
export Problem, TwoClass, MultiClass
export Format, TabularData

# dataset
abstract type Dataset end

hastrain(::Type{<:Dataset}) = true
hasvalid(::Type{<:Dataset}) = false
hastest(::Type{<:Dataset}) = false

# data format
abstract type Format end
abstract type Images <: Format end

struct TabularData <: Format
    asmatrix::Bool

    function TabularData(; asmatrix = false, kwargs...)
        return new(asmatrix)
    end
end

samplesdim(::Type{TabularData}) = 1

struct MatrixData <: Format end

samplesdim(::Type{MatrixData}) = 2

struct GrayImages <: Format end

samplesdim(::Type{GrayImages}) = 3

struct ColorImages <: Format end

samplesdim(::Type{ColorImages}) = 4

# data problem
abstract type Problem{D, F} end

samplesdim(::Problem{D, F}) where {D<:Dataset, F<:Format} = samplesdim(F)

struct TwoClass{D<:Dataset, F<:Format} <: Problem{D, F}
    format::F
    standardize::Bool
    seed::Int64

    function TwoClass(
        D::Type{<:Dataset},
        format::F;
        standardize = true,
        seed = 1234,
        kwargs...
    ) where {F<:Format}

        return new{D, F}(format, standardize, seed)
    end
end

struct MultiClass{D<:Dataset, F<:Format} <: Problem{D, F}
    format::F
    labelmap::Function
    standardize::Bool
    seed::Int64

    function MultiClass(
        D::Type{<:Dataset},
        format::F,
        labelmap = identity;
        standardize = true,
        seed = 1234,
        kwargs...
    ) where {F<:Format}

        return new{D, F}(format, labelmap, standardize, seed)
    end
end

include("utilities.jl")

function __init__()
    include.(readdir(joinpath(@__DIR__, "datasets", "uci"); join = true))
    include.(readdir(joinpath(@__DIR__, "datasets", "mnist"); join = true))
end

end # module
