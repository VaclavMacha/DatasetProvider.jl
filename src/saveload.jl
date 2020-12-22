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

function column_name(ind, col_categorical, col_targets)
    ind == col_targets && return :targets
    type = in(ind, col_categorical) ? "cat" : "num"
    return Symbol("$(type)$(ind)")
end

function uciprepare(
    path;
    col_categorical = Int[],
    col_remove = Int[],
    col_targets::Int = 0,
    pos_labels = [],
    kwargs...
)

    table = csvread(path; kwargs...)

    # rename and remove columns
    cols_remove = Int[]
    cols_names = Symbol[]
    id = 1
    for (col, name) in enumerate(propertynames(table))
        if in(col, col_remove)
            push!(cols_remove, col)
        elseif col == col_targets
            name = :targets
        elseif in(col, col_categorical)
            name = Symbol("cat", id)
            id += 1
        else
            name = Symbol("num", id)
            id += 1
        end
        push!(cols_names, name)
    end
    rename!(table, cols_names)
    select!(table, Not(cols_remove))

    # change targets position and binarize
    if hasproperty(table, :targets)
        y = table.targets
        if !isempty(pos_labels)
            y = data_binarize(y, pos_labels)
        end
        select!(table, Not(:targets))
        table.targets = y
    end
    return table
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
