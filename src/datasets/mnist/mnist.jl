abstract type AbstractMNIST <: Dataset end

problemtype(::Type{<:AbstractMNIST}) = MultiClass
formattype(::Type{<:AbstractMNIST}) = GrayImages
hastest(::Type{<:AbstractMNIST}) = true

# MNIST
struct MNIST <: AbstractMNIST end

function MNIST(; kwargs...)
    return MultiClass(MNIST, GrayImages(; kwargs...); kwargs...)
end

modulename(::Type{MNIST}) = MLDatasets.MNIST

# FashionMNIST
struct FashionMNIST <: AbstractMNIST end

function FashionMNIST(; kwargs...)
    return MultiClass(FashionMNIST, GrayImages(; kwargs...); kwargs...)
end

modulename(::Type{FashionMNIST}) = MLDatasets.FashionMNIST

# utilities
function load_raw(::MultiClass{D}, type) where {D <:AbstractMNIST}
    if type == :train
        x, y = modulename(D).traindata(Float64)
    elseif type == :test
        x, y = modulename(D).testdata(Float64)
    else
        error("$(type) dataset not provided for $(nameof(D))")
    end
    return x, y
end
