abstract type AbstractImageNet224 <: Name end
struct ImageNet224MMAP <: AbstractImageNet224 end
struct ImageNet224 <: AbstractImageNet224 end

const IMAGENET_PATH = Ref{String}(joinpath(DATADIR, "ImageNet224.h5"))
const IMAGENET_FILE = Ref{HDF5.File}(HDF5.File(-1, "nnn"))

function set_imagenet_path!(path)
    IMAGENET_PATH[] = path
end

function open_imagenet()
    if !isfile(IMAGENET_PATH[])
        error("File $(IMAGENET_PATH[]) does not exists. Use DatasetProvider.set_imagenet_path! function to set the proper path.")
    end
    fid = IMAGENET_FILE[]
    if !isopen(fid)
        IMAGENET_FILE[] = fid = h5open(IMAGENET_PATH[], "r")
    end
    return fid
end

close_imagenet() = close(IMAGENET_FILE[])

# download options
task(::Type{<:AbstractImageNet224}) = MultiClass
format(::Type{<:AbstractImageNet224}) = ColorImages
source(::Type{<:AbstractImageNet224}) = "https://image-net.org/"
version(::Type{<:AbstractImageNet224}) = "ILSVRC2012"
make_datadep(::Type{<:AbstractImageNet224}) = nothing

nclasses(::Type{<:AbstractImageNet224}) = 1000
classes(::Type{<:AbstractImageNet224}) = collect(1:1000)
nattributes(::Type{<:AbstractImageNet224}) = (224, 224, 3)
ninstances(::Type{<:AbstractImageNet224}) = (1281167, 0, 50000)

# dataset description
name(::Type{<:AbstractImageNet224}) = "ImageNet Large Scale Visual Recognition Challenge 2012"

function author(::Type{<:AbstractImageNet224})
    return ["Olga Russakovsky", "Jia Deng", "Hao Su", "Jonathan Krause", "Sanjeev Satheesh", "Sean Ma", "Zhiheng Huang", "Andrej Karpathy", "Aditya Khosla", "Michael Bernstein", "Alexander C. Berg", "Li Fei-Fei"]
end

function citation(::Type{<:AbstractImageNet224})
    return """
    @article{ILSVRC15,
        Author = {Olga Russakovsky and Jia Deng and Hao Su and Jonathan Krause and Sanjeev Satheesh and Sean Ma and Zhiheng Huang and Andrej Karpathy and Aditya Khosla and Michael Bernstein and Alexander C. Berg and Li Fei-Fei},
        Title = {{ImageNet Large Scale Visual Recognition Challenge}},
        Year = {2015},
        journal   = {International Journal of Computer Vision (IJCV)},
        doi = {10.1007/s11263-015-0816-y},
        volume={115},
        number={3},
        pages={211-252}
    }
    """
end

# loading
struct HDF5Array{T, N} <: AbstractArray{T, N}
    data
    inds

    function HDF5Array(data, inds = 1:size(data, ndims(data)))
        return new{eltype(data), ndims(data)}(data, inds)
    end
end

Base.size(A::HDF5Array) = (size(A.data)[1:end-1]..., length(A.inds))

Base.summary(A::HDF5Array{T, 1}) where {T} = "$(length(A))-element HDF5Vector{$T}"
Base.summary(A::HDF5Array{T, 2}) where {T} = "$(join(size(A), "x")) HDF5Matrix{$T}"
Base.summary(A::HDF5Array{T, N}) where {T, N} = "$(join(size(A), "x")) HDF5Array{$T}"

Base.show(io::IO, A::HDF5Array) = print(io, summary(A))
Base.show(io::IO, ::MIME"text/plain", A::HDF5Array) = show(io, A)

function Base.getindex(A::HDF5Array, I...)
    indices = Base.to_indices(A, I)
    return getindex(A.data, indices[1:end-1]..., A.inds[indices[end]])
end

function Base.setindex!(A::HDF5Array, v, I...)
    indices = Base.to_indices(A, I)
    return setindex!(A.data, v, indices[1:end-1]..., A.inds[indices[end]])
end

function Base.selectdim(A::HDF5Array{T,N}, d::Int, inds) where {T, N}
    if d != N
        throw(ArgumentError("only last dimension ($N) can be selected"))
    end
    return HDF5Array(A.data, A.inds[inds])
end

function loadraw(N::Type{<:AbstractImageNet224}, type)
    hassubset(N, type)
    split = type == :test ? "val" : "train"

    fid = open_imagenet()
    if N <: ImageNet224MMAP
        data = HDF5.readmmap(fid["$(split)_data"]) |> HDF5Array
    else
        @warn "due to the size of the ImageNet dataset, it may take several minutes to load data into memory"
        data = HDF5.read(fid["$(split)_data"])
    end
    targets = fid["$(split)_targets"][:]
    close(fid)
    return data, targets
end