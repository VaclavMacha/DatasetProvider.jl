abstract type AbstractDDSM <: Name end
struct DDSMMMAP <: AbstractDDSM end
struct DDSM <: AbstractDDSM end

const DDSM_PATH = Ref{String}(joinpath(DATADIR, "DDSM", "data.h5"))
const DDSM_FILE = Ref{HDF5.File}(HDF5.File(-1, "nnn"))

function set_DDSM_PATH!(path)
    DDSM_PATH[] = path
end

function open_ddsm()
    if !isfile(DDSM_PATH[])
        error("File $(DDSM_PATH[]) does not exists. Use DatasetProvider.set_DDSM_PATH! function to set the proper path.")
    end
    fid = DDSM_FILE[]
    if !isopen(fid)
        DDSM_FILE[] = fid = h5open(DDSM_PATH[], "r")
    end
    return fid
end

close_ddsm() = close(DDSM_FILE[])

# download options
task(::Type{<:AbstractDDSM}) = MultiClass
format(::Type{<:AbstractDDSM}) = GrayImages
source(::Type{<:AbstractDDSM}) = "https://www.kaggle.com/skooch/ddsm-mammography?select=test10_data"
make_datadep(::Type{<:AbstractDDSM}) = nothing

nclasses(::Type{<:AbstractDDSM}) = 4
classes(::Type{<:AbstractDDSM}) = collect(0:4)
nattributes(::Type{<:AbstractDDSM}) = (299, 299, 3)
ninstances(::Type{<:AbstractDDSM}) = (55890, 0, 15364)

# dataset description
name(::Type{<:AbstractDDSM}) = "DDSM Mammography"

function author(::Type{<:AbstractDDSM})
    return ["Eric A. Scuccimarra"]
end

# loading
function loadraw(N::Type{<:AbstractDDSM}, type)
    hassubset(N, type)
    split = type == :test ? "test" : "train"

    fid = open_ddsm()
    if N <: DDSMMMAP
        data = HDF5.readmmap(fid[split]["data"]) |> HDF5Array
    else
        @warn "due to the size of the DDSM dataset, it may take several minutes to load data into memory"
        data = HDF5.read(fid[split]["data"])
    end
    targets = fid[split]["labels"][:]
    close(fid)
    return data, targets
end