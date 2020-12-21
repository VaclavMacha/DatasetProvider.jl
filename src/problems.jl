struct TwoClass <: Problem
    TwoClass(; kwargs...) = new()
end


struct MultiClass <: Problem
    labels
    binarize
    poslabels
end

function MultiClass(labels; binarize = false, poslabels = [], kwargs...)
    if binarize && isempty(poslabels)
        throw(ArgumentError("positive labels must be provided for binarization"))
    end
    return MultiClass(labels, binarize, poslabels)
end
