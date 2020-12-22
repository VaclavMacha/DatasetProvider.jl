abstract type MLDataset <:Name end

function load_raw(N::Type{<:MLDataset}, type)
    if type == :train
        x, y = modulename(N).traindata(Float64)
    elseif type == :test
        x, y = modulename(N).testdata(Float64)
    else
        error("$(type) dataset not provided for $(nameof(N))")
    end
    return x, y
end

#-------------------------------------------------------------------------------------------
# MNIST-like datasets
#-------------------------------------------------------------------------------------------
abstract type AbstractMNIST <: MLDataset end

problemtype(::Type{<:AbstractMNIST}) = MultiClass
formattype(::Type{<:AbstractMNIST}) = GrayImages
hastest(::Type{<:AbstractMNIST}) = true

struct MNIST <: AbstractMNIST end

MNIST(; kwargs...) = Dataset(MNIST; kwargs...)
modulename(::Type{MNIST}) = MLDatasets.MNIST
problem(::Type{MNIST}; kwargs...) = MultiClass(collect(0:9); kwargs...)

struct FashionMNIST <: AbstractMNIST end

FashionMNIST(; kwargs...) = Dataset(FashionMNIST; kwargs...)
modulename(::Type{FashionMNIST}) = MLDatasets.FashionMNIST
problem(::Type{FashionMNIST}; kwargs...) = MultiClass(collect(0:9); kwargs...)

#-------------------------------------------------------------------------------------------
# CIFAR datasets
#-------------------------------------------------------------------------------------------
abstract type AbstractCIFAR <: MLDataset end

problemtype(::Type{<:AbstractCIFAR}) = MultiClass
formattype(::Type{<:AbstractCIFAR}) = ColorImages
hastest(::Type{<:AbstractCIFAR}) = true

struct CIFAR10 <: AbstractCIFAR end

CIFAR10(; kwargs...) = Dataset(CIFAR10; kwargs...)
modulename(::Type{CIFAR10}) = MLDatasets.CIFAR10
problem(::Type{CIFAR10}; kwargs...) = MultiClass(collect(1:10); kwargs...)

struct CIFAR20 <: AbstractCIFAR end

CIFAR20(; kwargs...) = Dataset(CIFAR20; kwargs...)
modulename(::Type{CIFAR20}) = MLDatasets.CIFAR100
problem(::Type{CIFAR20}; kwargs...) = MultiClass(collect(1:20); kwargs...)

struct CIFAR100 <: AbstractCIFAR end

CIFAR100(; kwargs...) = Dataset(CIFAR100; kwargs...)
modulename(::Type{CIFAR100}) = MLDatasets.CIFAR100
problem(::Type{CIFAR100}; kwargs...) = MultiClass(collect(1:100); kwargs...)

# custom load_raw function for CIFAR100
function load_raw(N::Type{CIFAR100}, type)
    if type == :train
        x, ~, y = modulename(N).traindata(Float64)
    elseif type == :test
        x, ~, y = modulename(N).testdata(Float64)
    else
        error("$(type) dataset not provided for $(nameof(N))")
    end
    return x, y
end

#-------------------------------------------------------------------------------------------
# SVHN2 datasets
#-------------------------------------------------------------------------------------------
abstract type AbstractSVHN2 <: MLDataset end

problemtype(::Type{<:AbstractSVHN2}) = MultiClass
formattype(::Type{<:AbstractSVHN2}) = ColorImages
hastest(::Type{<:AbstractSVHN2}) = true

struct SVHN2 <: AbstractSVHN2 end

SVHN2(; kwargs...) = Dataset(SVHN2; kwargs...)
modulename(::Type{SVHN2}) = MLDatasets.SVHN2
problem(::Type{SVHN2}; kwargs...) = MultiClass(collect(1:10); kwargs...)

struct SVHN2Extra <: AbstractSVHN2 end

SVHN2Extra(; kwargs...) = Dataset(SVHN2Extra; kwargs...)
modulename(::Type{SVHN2Extra}) = MLDatasets.SVHN2
problem(::Type{SVHN2Extra}; kwargs...) = MultiClass(collect(1:10); kwargs...)


function load_raw(N::Type{SVHN2Extra}, type)
    if type == :train
        xtrain, ytrain = modulename(N).traindata(Float64)
        xextra, yextra = modulename(N).extradata(Float64)
        x = cat(xtrain, xextra; dims = 4)
        x = cat(ytrain, yextra; dims = 1)
    elseif type == :test
        x, y = modulename(N).testdata(Float64)
    else
        error("$(type) dataset not provided for $(nameof(N))")
    end
    return x, y
end
