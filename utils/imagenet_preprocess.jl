using Tar, ProgressMeter

# extraction
const IMAGENET_DIR = "./data/ImageNet"
const IMAGENET_VERSION = "ILSVRC2012"

function extract_train(file)
    dir = joinpath(IMAGENET_DIR, "train")
    tmp1 = joinpath(IMAGENET_DIR, "tmp")
    mkpath(dir)
    Tar.extract(file, tmp1)

    @showprogress for file in readdir(tmp1; join = true)
        tmp2 = Tar.extract(file)
        datadir = joinpath(dir, basename(file)[1:end-4])
        mkpath(datadir)
        files = readdir(tmp2)
        mv.(joinpath.(tmp2, files), joinpath.(datadir, files))
    end
    rm(tmp1; recursive = true)
    return 
end

function extract_test(file)
    dir = joinpath(IMAGENET_DIR, "test")
    mkpath(dir)
    Tar.extract(file, dir)
    return 
end

extract_train(IMAGENET_DIR * "/$(IMAGENET_VERSION)_img_train.tar")
extract_test(IMAGENET_DIR * "/$(IMAGENET_VERSION)_img_val.tar")