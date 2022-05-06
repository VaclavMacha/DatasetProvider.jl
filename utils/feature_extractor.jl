#!/usr/bin/env sh
#SBATCH --partition=amdfast
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=10 
#SBATCH --mem=200G
#=
export JULIA_NUM_THREADS=20

srun --unbuffer julia --color=no --startup-file=no "${BASH_SOURCE[0]}" "$@"
exit
=#

using Pkg
Pkg.activate("/home/machava2/projects/DatasetProvider.jl")

const EXTRACTOR = "/home/machava2/projects/DatasetProvider.jl/utils/jrm_adk_103"

using ProgressMeter, HDF5

function extract_features(path::AbstractString; T=Float32)
    features = split(readchomp(`$EXTRACTOR -q $path`))[2:end]
    length(features) != 22510 && error("Output does not match expected size")
    return parse.(T, features)
end


function extract_features_dir(dir::AbstractString; T=Float32)
    files = filter(file -> endswith(file, ".jpg"), readdir(dir; join=true))
    k = length(files)
    X = zeros(T, k, 22510)

    p = Progress(k)
    Threads.@threads for i in 1:k
        X[i, :] .= extract_features(files[i]; T)
        next!(p)
    end
    return X
end

const ALASKA = "/home/machava2/projects/DatasetProvider.jl/data/ALASKA/"

dirs = [
    "JMiPOD_0005",
    "JMiPOD_001",
    "JMiPOD_04",
    "cover",
]

for dir in dirs
    @info dir
    isfile(joinpath(ALASKA, "$(dir).h5")) && continue

    X = extract_features_dir(joinpath(ALASKA, dir))
    h5open(joinpath(ALASKA, "$(dir).h5"), "w") do file
        write(file, "data", X)
    end
end
