abstract type Task end
args(::Type{<:Task}; kwargs...) = (;)
postprocess(::Type{<:Task}, data; kwargs...) = data

abstract type Format end
args(::Type{<:Format}; kwargs...) = (;)
postprocess(::Type{<:Format}, data; kwargs...) = data

abstract type Name{F, T} end

struct MandatoryMethod <: Exception
    method::String
    N::Type{<:Name}
end

function Base.showerror(io::IO, e::MandatoryMethod)
    print(io, "MandatoryMethod: method `$(e.method)(::Type{$(nameof(e.N))})` not defined")
end

# mandatory methods
problem(::N) where {N <: Name} = throw(MandatoryMethod("problem", N))
format(::N) where {N <: Name}= throw(MandatoryMethod("format", N))
source(::N) where {N <: Name}= throw(MandatoryMethod("source", N))
downloadlink(::N) where {N <: Name}= throw(MandatoryMethod("downloadlink", N))
preprocess(::N) where {N <: Name}= throw(MandatoryMethod("preprocess", N))
nattributes(::N) where {N <: Name}= throw(MandatoryMethod("nattributes", N))
ninstances(::N) where {N <: Name}= throw(MandatoryMethod("ninstances", N))

# optional methods
datadepname(::N) where {N <: Name}= string(nameof(N))
checksum(::Name) = ""
name(::N) where {N <: Name}= string(nameof(N))
author(::Name) = String[]
licence(::Name) = ""
citation(::Name) = ""

struct Dataset{N<:Name}
    name::N
    shuffle::Bool
    seed::Int64
    fargs
    targs

    function Dataset(
        d::N{F, T};
        shuffle::Bool = false,
        seed::Int64 = 1234,
        kwargs...
    ) where {N<:Name, F<:Format, T<:Task}
        return new(shuffle, seed, args(F; kwargs...), args(T; kwargs...))
    end
end

function Base.show(io::IO, data::Dataset{N}) where {N<:Name}
    args = (shuffle = data.shuffle, seed = data.seed)
    print(io, nameof(N), merge(args, data.pargs, data.fargs))
    return
end
