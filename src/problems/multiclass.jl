struct MultiClass <: Problem
    binarize
    poslabels
end

function MultiClass(N::Type{<:Name}; binarize = false, poslabels = [], kwargs...)
    if binarize && isempty(poslabels)
        throw(ArgumentError("positive labels must be provided for binarization"))
    end
    if !isempty(poslabels) && !all(in.(poslabels, Ref(classes(N))))
        throw(ArgumentError("provided positive labels differ from actual labels"))
    end
    return MultiClass(binarize, poslabels)
end

function postprocess(problem::MultiClass, data)
    return data_binarize(data, problem.poslabels, problem.binarize)
end
