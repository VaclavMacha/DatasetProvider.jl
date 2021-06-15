hassubset(N::Type{<:Name}, type::Symbol) = hassubset(N, Val(type))
function hassubset(::Type{<:Name}, type::Val)
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

# MLDatasets
loadraw_mldatasets(modul_name, type::Symbol) = loadraw_mldatasets(modul_name, Val(type))
function loadraw_mldatasets(::Type{<:Name}, type::Val)
    throw(ArgumentError("$(type) subset not supported. Possible choices: :train, :test"))
end
loadraw_mldatasets(dataset, ::Val{:train}, T = Float32) = dataset.traindata(T)
loadraw_mldatasets(dataset, ::Val{:test}, T = Float32) = dataset.testdata(T)

# unzip
function unzip(path; clearpath = true, rename = identity, skip = (f) -> false)
    r = ZipFile.Reader(path)
    for f in filter(!skip, r.files)
        write(joinpath(dirname(path), rename(f.name)), read(f, String))
    end
    clearpath && rm(path)
    return
end

"""
    remove(N::Type{<:Name})
Removes given dataset `N`, if installed.
"""
function remove(N::Type{<:Name})
    path = DataDeps.try_determine_load_path(datadepname(N), @__DIR__)
    if !isnothing(path)
        rm(path; recursive = true)
        printstyled(" ✖ $(nameof(N)) dataset removed \n"; color = :red)
    else
        printstyled(" ✖ $(nameof(N)) dataset not installed \n"; color = :red)
    end
    return
end

"""
    removeall()
Removes all downloaded datasets.
"""
function removeall()
    if DataDeps.input_bool("Do you want to remove all downloaded datasets?")
        remove.(name_subtypes())
    end
    return
end

"""
    listdatasets()
Prints the names of all available datasets and highlights datasets that have already been downloaded. Datasets are sorted into groups based on their problem type and format type.
"""
function listdatasets()
    Ns = name_subtypes()
    Ts = task_subtypes()
    Fs = format_subtypes()

    for T in Ts
        printstyled("$(nameof(T)): \n"; color = :blue, bold = true)
        for F in Fs
            datasets = [N for N in Ns if task(N) <: T && format(N) <: F]
            isempty(datasets) && continue
            printstyled("  $(nameof(F)): \n"; color = :yellow, bold = true)
            for N in datasets
                path = DataDeps.try_determine_load_path(datadepname(N), @__DIR__)
                if isnothing(path)
                    printstyled("    ✖ $(nameof(N)) \n"; color = :red)
                else
                    printstyled("    ✔ $(nameof(N)) \n"; color = :green, bold = true)
                end
            end
        end
    end
    return
end