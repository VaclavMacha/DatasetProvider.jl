abstract type AbstractEmber <: Name end
struct Ember <: AbstractEmber end

const EMBER_PATH = Ref{String}(joinpath(DATADIR, "Ember2018.h5"))
const EMBER_FILE = Ref{HDF5.File}(HDF5.File(-1, "nnn"))

function set_ember_path!(path)
    EMBER_PATH[] = path
end

function open_ember()
    if !isfile(EMBER_PATH[])
        error("File $(EMBER_PATH[]) does not exists. Use DatasetProvider.set_ember_path! function to set the proper path.")
    end
    fid = EMBER_FILE[]
    if !isopen(fid)
        EMBER_FILE[] = fid = h5open(EMBER_PATH[], "r")
    end
    return fid
end

close_ember() = close(EMBER_FILE[])

# download options
task(::Type{<:AbstractEmber}) = MultiClass
format(::Type{<:AbstractEmber}) = MatrixFormat
source(::Type{<:AbstractEmber}) = "https://github.com/elastic/ember"
version(::Type{<:AbstractEmber}) = "2018"
make_datadep(::Type{<:AbstractEmber}) = nothing

nclasses(::Type{<:AbstractEmber}) = 3
classes(::Type{<:AbstractEmber}) = [-1, 0, 1]
nattributes(::Type{<:AbstractEmber}) = (2381, )
ninstances(::Type{<:AbstractEmber}) = (800000, 0, 200000)

# dataset description
function loadraw(N::Type{<:AbstractEmber}, type)
    hassubset(N, type)

    fid = open_ember()
    data = HDF5.read(fid["$(type)"]["data"])
    targets = HDF5.read(fid["$(type)"]["targets"])
    close(fid)
    return data, targets
end
