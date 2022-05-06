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
task(::Type{Ember}) = TwoClass
format(::Type{Ember}) = MatrixFormat
source(::Type{Ember}) = "https://github.com/elastic/ember"
version(::Type{Ember}) = "2018"
make_datadep(::Type{Ember}) = nothing

nattributes(::Type{Ember}) = (2381,)
ninstances(::Type{Ember}) = (600000, 0, 100000)
positivelabel(::Type{Ember}) = 1

# dataset description
function loadraw(N::Type{Ember}, type)
    hassubset(N, type)

    fid = open_ember()
    targets = HDF5.read(fid["$(type)"]["targets"])
    inds = findall(targets .!= -1)
    data = HDF5.read(fid["$(type)"]["data"])[inds, :]
    targets = targets[inds] .== 1
    close(fid)
    return data, targets
end
