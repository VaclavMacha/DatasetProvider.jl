# Dataset Name
abstract type Name end

struct MandatoryMethod <: Exception
    method::String
    N::Type{<:Name}
end

function Base.showerror(io::IO, e::MandatoryMethod)
    print(io, "MandatoryMethod: method `$(e.method)(::Type{$(nameof(e.N))})` not defined")
end

## Mandatory methods
format(N::Type{<:Name}) = throw(MandatoryMethod("format", N))
task(N::Type{<:Name}) = throw(MandatoryMethod("problem", N))
source(N::Type{<:Name}) = throw(MandatoryMethod("source", N))
downloadlink(N::Type{<:Name}) = throw(MandatoryMethod("downloadlink", N))
preprocess(N::Type{<:Name}) = throw(MandatoryMethod("preprocess", N))
nattributes(N::Type{<:Name}) = throw(MandatoryMethod("nattributes", N))
ninstances(N::Type{<:Name}) = throw(MandatoryMethod("ninstances", N))

## Optional methods
checksum(::Type{<:Name}) = ""
datadepname(N::Type{<:Name})= string(nameof(N))
name(N::Type{<:Name})= string(nameof(N))
author(::Type{<:Name}) = String[]
licence(::Type{<:Name}) = ""
citation(::Type{<:Name}) = ""

## Registration
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

# Dataset Task
abstract type Task end
args(::Type{<:Task}; kwargs...) = (;)
postprocess(::Type{<:Name}, ::Type{<:Task}, data; kwargs...) = data

# Dataset Format
abstract type Format end
args(::Type{<:Format}; kwargs...) = (;)
postprocess(::Type{<:Name}, ::Type{<:Format}, data; kwargs...) = data


abstract type Split end
