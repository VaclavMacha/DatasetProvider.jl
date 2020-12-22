function csvread(
    path;
    header = false,
    typemap = Dict(Date => String, DateTime => String),
    missingstrings = ["", "NA", "?", "*", "#DIV/0!"],
    truestrings = ["T", "t", "TRUE", "true", "y", "yes"],
    falsestrings = ["F", "f", "FALSE", "false", "n", "no"],
    kwargs...
)
    return CSV.File(
        path;
        header,
        typemap,
        missingstrings,
        truestrings,
        falsestrings,
        kwargs...
    ) |> DataFrame
end

"""
    datapath(N::Type{<:Name}, type::Symbol)

Returns the path to the file in which the `type` subset of dataset `N` is stored and download the dataset if it not installed yet. Valid subset types are: `:train`, `:valid`, `:test`.
"""
function datapath(N::Type{<:Name}, type::Symbol)
    if !hassubset(N, type)
        throw(ArgumentError("$(type) subset not provided for $(nameof(N)) dataset"))
    end
    F = formattype(N)
    return joinpath(@datadep_str("$(nameof(N))"), "data_$(type).$(saveformat(F))")
end

function save_raw(N::Type{<:Name}, path, type, data; clearpath = true)
    save_raw(formattype(N), datapath(N, type), data)
    clearpath && rm(path)
    return
end

load_raw(N::Type{<:Name}, type) = load_raw(formattype(N), datapath(N, type))
