abstract type AllImages <: Format end
struct GrayImages <: AllImages end
struct ColorImages <: AllImages end

saveformat(::Type{<:AllImages}) = "bson"
samplesdim(::Type{GrayImages}) = 3
samplesdim(::Type{ColorImages}) = 4
