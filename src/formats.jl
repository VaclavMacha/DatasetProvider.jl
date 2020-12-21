saveformat(::Type{<:Format}) = "bson"
save_raw(::Type{<:Format}, path, data) = BSON.bson(path, data)
function load_raw(::Type{<:Format}, path)
    dict = BSON.bson(path)
    return dict[:data], dict[:labels]
end


struct TabularData <: Format
    asmatrix::Bool

    TabularData(; asmatrix = false, kwargs...) = new(asmatrix)
end

samplesdim(::Type{TabularData}) = 1
saveformat(::Type{TabularData}) = "csv"
save_raw(::Type{TabularData}, path, data) = CSV.write(path, data)
load_raw(::Type{TabularData}, path) = CSV.File(path; header = true) |> DataFrame


struct MatrixData <: Format
    MatrixData(; kwargs...) = new()
end

samplesdim(::Type{MatrixData}) = 2


abstract type Images <: Format end

struct GrayImages <: Format
    GrayImages(; kwargs...) = new()
end

samplesdim(::Type{GrayImages}) = 3


struct ColorImages <: Format
    ColorImages(; kwargs...) = new()
end

samplesdim(::Type{ColorImages}) = 4
