struct Dataset{N<:Name, P<:Problem, F<:Format}
    problem::P
    format::F
    shuffle::Bool
    seed::Int64

    function Dataset(
        N::Type{<:Name},
        problem::P,
        format::F;
        shuffle::Bool = false,
        seed::Int64 = 1234,
        kwargs...
    ) where {P<:Problem, F<:Format}

        return new{N, P, F}(problem, format, shuffle, seed)
    end
end

function Dataset(N::Type{<:Name}; kwargs...)
    problem = problemtype(N)(N; kwargs...)
    format = formattype(N)(N; kwargs...)
    return Dataset(N, problem, format; kwargs...)
end

function Base.show(io::IO, data::Dataset{N}) where {N<:Name}
    vals = getfield.(Ref(data), fieldnames(Dataset))
    print(io, nameof(N), "(", join(vals, ", "), ")")
    return
end

function postprocess(dataset::Dataset, data)
    data = postprocess(dataset.format, data)
    data = postprocess(dataset.problem, data)
    return copy.(data)
end
