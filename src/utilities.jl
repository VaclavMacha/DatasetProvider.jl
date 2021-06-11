hassubset(N::Type{<:Name}, type::Symbol) = hassubset(N, Val(type))
function hassubset(::Type{<:Name}, ::Val)
    throw(ArgumentError("$(type) subset not supported. Possible choices: :train, :valid, :test"))
end
hassubset(N::Type{<:Name}, ::Val{:train}) = ninstances(N)[1] > 0
hassubset(N::Type{<:Name}, ::Val{:valid}) = ninstances(N)[2] > 0
hassubset(N::Type{<:Name}, ::Val{:test}) = ninstances(N)[3] > 0

"""
    datapath(N::Type{<:Name}, type::Symbol)

Returns the path to the file in which the `type` subset of dataset `N` is stored and download the dataset if it not installed yet. Valid subset types are: `:train`, `:valid`, `:test`.
"""
function datapath(N::Type{<:Name}, type::Symbol)
    if !hassubset(N, type)
        throw(ArgumentError("$(type) subset not provided for $(nameof(N)) dataset"))
    end
    ext = saveformat(format(N))
    return joinpath(datadir(N), "data_$(type).$(ext)")
end

datadir(N::Type{<:Name}) = @datadep_str(datadepname(N))

function saveraw(N::Type{<:Name}, path, type, data; clearpath = true)
    saveraw(format(N), datapath(N, type), data)
    clearpath && rm(path)
    return
end

loadraw(N::Type{<:Name}, type) = loadraw(format(N), datapath(N, type))

hasmeta(N::Type{<:Name}) = isfile(joinpath(datadir(N), "meta.bson"))
savemeta(N::Type{<:Name}, meta) = BSON.bson(joinpath(datadir(N), "meta.bson"), meta)
loadmeta(N::Type{<:Name}) = BSON.load(joinpath(datadir(N), "meta.bson"))