abstract type AbstractCIFAR <: Dataset end

problemtype(::Type{<:AbstractCIFAR}) = MultiClass
formattype(::Type{<:AbstractCIFAR}) = ColorImages
hastest(::Type{<:AbstractCIFAR}) = true

# CIFAR10
struct CIFAR10 <: AbstractCIFAR end

function CIFAR10(; kwargs...)
    return MultiClass(CIFAR10, ColorImages(; kwargs...); kwargs...)
end

modulename(::Type{CIFAR10}) = MLDatasets.CIFAR10

# CIFAR20
struct CIFAR20 <: AbstractCIFAR end

function CIFAR20(; kwargs...)
    return MultiClass(CIFAR20, ColorImages(; kwargs...); kwargs...)
end

modulename(::Type{CIFAR20}) = MLDatasets.CIFAR100

# CIFAR100
struct CIFAR100 <: AbstractCIFAR end

function CIFAR100(; kwargs...)
    return MultiClass(CIFAR100, ColorImages(; kwargs...); kwargs...)
end

modulename(::Type{CIFAR100}) = MLDatasets.CIFAR100

# utilities
function load_raw(::MultiClass{D}, type) where {D <:AbstractCIFAR}
    if type == :train
        x, y = modulename(D).traindata(Float64)
    elseif type == :test
        x, y = modulename(D).testdata(Float64)
    else
        error("$(type) dataset not provided for $(nameof(D))")
    end
    return x, y
end

function load_raw(::MultiClass{CIFAR100}, type)
    if type == :train
        x, ~, y = modulename(D).traindata(Float64)
    elseif type == :test
        x, ~, y = modulename(D).testdata(Float64)
    else
        error("$(type) dataset not provided for $(nameof(D))")
    end
    return x, y
end
