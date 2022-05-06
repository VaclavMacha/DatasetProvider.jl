abstract type AbstractALASKA <: Name end
abstract type ALASKAFeatures <: AbstractALASKA end
abstract type ALASKAImages <: AbstractALASKA end

struct ALASKAFeaturesJMiPOD04 <: ALASKAFeatures end
struct ALASKAFeaturesJMiPOD001 <: ALASKAFeatures end
struct ALASKAFeaturesJMiPOD0005 <: ALASKAFeatures end

struct ALASKAJMiPOD04 <: ALASKAImages end
struct ALASKAJMiPOD001 <: ALASKAImages end
struct ALASKAJMiPOD0005 <: ALASKAImages end


const ALASKA_DIR = Ref{String}(joinpath(DATADIR, "ALASKA"))

function set_ALASKA_DIR!(path)
    ALASKA_DIR[] = path
end

alaskadir(args...) = joinpath(ALASKA_DIR[], args...)

# download options
task(::Type{<:AbstractALASKA}) = TwoClass
source(::Type{<:AbstractALASKA}) = ""
make_datadep(::Type{<:AbstractALASKA}) = nothing
ninstances(::Type{<:AbstractALASKA}) = (160010, 0, 0)

format(::Type{<:ALASKAImages}) = GrayImages
nattributes(::Type{<:ALASKAImages}) = (262144,)

format(::Type{<:ALASKAFeatures}) = MatrixFormat
nattributes(::Type{<:ALASKAFeatures}) = (22510,)

# loading features
alaska_steg(N::Type{ALASKAFeaturesJMiPOD04}) = "JMiPOD_04.h5"
alaska_steg(N::Type{ALASKAFeaturesJMiPOD001}) = "JMiPOD_001.h5"
alaska_steg(N::Type{ALASKAFeaturesJMiPOD0005}) = "JMiPOD_0005.h5"


function loadraw(N::Type{<:ALASKAFeatures}, type)
    hassubset(N, type)
    @warn "due to the size of the ALASKA dataset, it may take some time to load data into memory"

    X_cover = h5open(alaskadir("cover.h5"), "r") do file
        read(file, "data")
    end
    X_steg = h5open(alaskadir(alaska_steg(N)), "r") do file
        read(file, "data")
    end
    data = vcat(X_cover, X_steg)
    targets = (1:size(data, 1)) .> size(X_cover, 1)
    return data, targets
end

# loading features
alaska_steg(N::Type{ALASKAJMiPOD04}) = "JMiPOD_04"
alaska_steg(N::Type{ALASKAJMiPOD001}) = "JMiPOD_001"
alaska_steg(N::Type{ALASKAJMiPOD0005}) = "JMiPOD_0005"

im_size(::Type{<:ALASKAImages}) = (512, 512)

struct FileDataset{N,T<:AbstractString}
    loadfn::Function
    paths::Vector{T}

    FileDataset(N, loadfn, paths) = new{N,eltype(paths)}(loadfn, paths)
end

function Base.getindex(dataset::FileDataset, i::Integer)
    dataset.loadfn(dataset.paths[i])
end
function Base.getindex(dataset::FileDataset{N}, is) where {N}
    x = zeros(Float32, im_size(N)..., length(is))
    Threads.@threads for i in 1:length(is)
        x[:, :, i] = dataset[is[i]]
    end
    return x
end
Base.length(dataset::FileDataset) = length(dataset.paths)

function Base.selectdim(dataset::FileDataset{N}, d::Int, inds) where {N}
    return FileDataset(N, dataset.loadfn, dataset.paths[inds])
end

loadimage(path) = channelview(jpeg_decode(path))

function loadraw(N::Type{<:ALASKAImages}, type)
    hassubset(N, type)

    files_cover = readdir(alaskadir("cover"); join=true)
    files_steg = readdir(alaskadir(alaska_steg(N)); join=true)
    data = FileDataset(N, loadimage, vcat(files_cover, files_steg))
    targets = (1:length(data)) .> length(files_cover)
    return data, targets
end
