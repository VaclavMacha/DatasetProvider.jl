struct ColorImages <: Format end

ColorImages(::Type{<:Name}; kwargs...) = ColorImages()
samplesdim(::Type{ColorImages}) = 4
saveformat(::Type{ColorImages}) = "bson"
