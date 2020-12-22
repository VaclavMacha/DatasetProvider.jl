struct TabularData <: Format
    asmatrix::Bool

    TabularData(; asmatrix = false, kwargs...) = new(asmatrix)
end

samplesdim(::Type{TabularData}) = 1
saveformat(::Type{TabularData}) = "csv"
save_raw(::Type{TabularData}, path, data) = CSV.write(path, data)
load_raw(::Type{TabularData}, path) = CSV.File(path; header = true) |> DataFrame

function postprocess(format::TabularData, data::AbstractDataFrame)
    if format.asmatrix
        y = data.labels
        x = select(data, Not(:labels))
        return Array(x), y
    else
        return data
    end
end


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
