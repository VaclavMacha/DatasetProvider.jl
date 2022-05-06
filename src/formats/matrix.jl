struct MatrixFormat <: Format end

saveformat(::Type{MatrixFormat}) = "h5"
samplesdim(::Type{MatrixFormat}) = 1

function args(
    ::Type{MatrixFormat};
    flux=true,
    kwargs...
)

    return (; flux)
end

function postprocess(
    N::Type{<:Name},
    ::Type{<:MatrixFormat},
    data;
    flux,
    kwargs...
)

    x, y = data
    if flux
        x = permutedims(x, (2, 1))
        y = Matrix{eltype(y)}(reshape(y, 1, :))
    end
    return x, y
end