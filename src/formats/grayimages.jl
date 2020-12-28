struct GrayImages <: Format end

GrayImages(::Type{<:Name}; kwargs...) = GrayImages()
samplesdim(::Type{GrayImages}) = 3
saveformat(::Type{GrayImages}) = "bson"
