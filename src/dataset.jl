struct Dataset{N<:Name, F<:Format, T<:Task}
    shuffle::Bool
    seed::Int64
    format_args
    task_args

    function Dataset(
        N::Type{<:Name};
        shuffle::Bool = false,
        seed::Int64 = 1234,
        kwargs...
    )   
        F = format(N)
        T = task(N)
        return new{N, F, T}(shuffle, seed, args(F; kwargs...), args(T; kwargs...))
    end
end

function Base.show(io::IO, data::Dataset{N, F, T}) where {N, F, T}
    args = (shuffle = data.shuffle, seed = data.seed)
    print(io, nameof(N), merge(args, data.format_args, data.task_args))
    return
end
