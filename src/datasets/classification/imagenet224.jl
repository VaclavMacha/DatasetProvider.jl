struct ImageNet224 <: Name end

const IMAGENET224_DIR = joinpath(DATADIR, "ImageNet224/") 

# download options
task(::Type{ImageNet224}) = MultiClass
format(::Type{ImageNet224}) = ColorImages
source(::Type{ImageNet224}) = "https://image-net.org/"
version(::Type{ImageNet224}) = "ILSVRC2012"
make_datadep(::Type{ImageNet224}) = nothing

nclasses(::Type{ImageNet224}) = 1000
classes(::Type{ImageNet224}) = collect(1:1000)
nattributes(::Type{ImageNet224}) = (224, 224, 3)
ninstances(::Type{ImageNet224}) = (1281167, 0, 50000)

# dataset description
name(::Type{ImageNet224}) = "ImageNet Large Scale Visual Recognition Challenge 2012"

function author(::Type{ImageNet224})
    return ["Olga Russakovsky", "Jia Deng", "Hao Su", "Jonathan Krause", "Sanjeev Satheesh", "Sean Ma", "Zhiheng Huang", "Andrej Karpathy", "Aditya Khosla", "Michael Bernstein", "Alexander C. Berg", "Li Fei-Fei"]
end

function citation(::Type{ImageNet224})
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
function create_label_map(file::String)
    m = MAT.matread(file)["synsets"]
    key = filter(x -> contains(x, "_ID"), collect(keys(m)))[1]
    return Dict(String.(m["WNID"]) .=> Int.(m[key]))
end

function data_table(::Val{:train}, image_dir)
    file = joinpath(image_dir, "data_train.csv")

    if !isfile(file)
        label_map = create_label_map(joinpath(image_dir, "meta.mat"))
        dfs = map(readdir(joinpath(image_dir, "train"); join = true)) do dir
            return DataFrame(
                files = readdir(dir; join = true),
                labels = label_map[basename(dir)],
                category = dir,
            )
        end
        df = reduce(vcat, dfs)
        CSV.write(file, df)
    end
    return CSV.read(file, DataFrame)
end

function data_table(::Val{:test}, image_dir)
    file = joinpath(image_dir, "data_test.csv")

    if !isfile(file)
        label_map = create_label_map(joinpath(image_dir, "meta.mat"))
        labels = readdlm(joinpath(image_dir, "test_labels.txt")) |> vec
        rev_map = Dict(values(label_map) .=> keys(label_map))

        df = DataFrame(
            files = readdir(joinpath(image_dir, "test"); join = true),
            labels = labels,
            category = [rev_map[label] for label in labels],
        )
        CSV.write(file, df)
    end
    return CSV.read(file, DataFrame)
end

struct ColorImageArray{T, N, W, H} <: AbstractArray{T, N}
    files::Vector{String}

    ColorImageArray(files, size::NTuple{2, Int}; T = Float32) = new{T, 4, size...}(files)
end

function Base.show(io::IO, ::MIME"text/plain", A::ColorImageArray{T, N}) where {T, N}
    return print(io, join(size(A), "x"), " ColorImageArray{$T, $N}") 
end

function Base.show_nd(io::IO, A::ColorImageArray{T, N}, ::Function, ::Bool) where {T, N}
    return print(io, join(size(A), "x"), " ColorImageArray{$T, $N}")
end

function Base.size(A::ColorImageArray{T, N, W, H}) where {T, N, W, H}
    return (W, H, 3, length(A.files))
end

function load_image(file::String)
    img = PNGFiles.load(file)
    return PermutedDimsArray(channelview(img), (2,3,1))
end

function Base.getindex(A::ColorImageArray{T,N}, i1, i2 ,i3, i4::Int) where {T, N}
    return getindex(T.(load_image(A.files[i4])), i1, i2, i3)
end

function Base.getindex(A::ColorImageArray{T,N,W,H}, i1, i2 ,i3, i4) where {T, N, W, H}
    X = Array{T}(undef, size(A)[1:3]..., length(i4))

    for (j, i) in enumerate(i4)
        X[:, :, :, j] .= load_image(A.files[i])
    end
    return getindex(X, i1, i2, i3, 1:length(i4))
end

function Base.setindex!(::ColorImageArray{T,N}, v, I::Vararg{Int,N}) where {T,N}
    @warn "setindex! not supported fo ColorImageArray"
    return 
end

function Base.selectdim(A::ColorImageArray{T,N,W,H}, d::Int, i) where {T, N, W, H}
    if d != 4
        throw(ArgumentError("only 4th dimension can be selected"))
    end
    return ColorImageArray(A.files[i], (W, H); T)
end

function loadraw(N::Type{ImageNet224}, type)
    hassubset(N, type)
    df = data_table(Val(type), IMAGENET224_DIR)
    return ColorImageArray(df.files, (224, 224)), df.labels
end