struct TwoClass <: Problem
    TwoClass(; kwargs...) = new()
end

Base.show(io::IO, ::TwoClass) = println(io, "TwoClass")

struct MultiClass <: Problem
    labels
    binarize
    poslabels
end

function MultiClass(labels; binarize = false, poslabels = [], kwargs...)
    if binarize && isempty(poslabels)
        throw(ArgumentError("positive labels must be provided for binarization"))
    end
    if !isempty(poslabels) && !all(in(poslabels, Ref(labels)))
        throw(ArgumentError("provided positive labels differ from actual labels"))
    end
    return MultiClass(labels, binarize, poslabels)
end

function Base.show(io::IO, problem::MultiClass)
    if problem.binarize
        println(io, "MultiClass(", join((problem.poslabels...,), ","), ")")
    else
        println(io, "MultiClass")
    end
end

function postprocess(problem::MultiClass, data)
    return data_binarize(data, problem.poslabels, problem.binarize)
end
