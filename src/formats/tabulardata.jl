struct TabularData <: Format
    asmatrix::Bool
end

TabularData(::Type{<:Name}; asmatrix = false, kwargs...) = TabularData(asmatrix)
samplesdim(::Type{TabularData}) = 1
saveformat(::Type{TabularData}) = "csv"
save_raw(::Type{TabularData}, path, data) = CSV.write(path, data)
load_raw(::Type{TabularData}, path) = CSV.read(path, DataFrame; header = true)


# preprocessing
function csvread(
    path;
    header = false,
    typemap = Dict(Date => String, DateTime => String),
    missingstrings = ["", "NA", "?", "*", "#DIV/0!"],
    truestrings = ["T", "t", "TRUE", "true", "y", "yes"],
    falsestrings = ["F", "f", "FALSE", "false", "n", "no"],
    kwargs...
)
    return CSV.read(
        path,
        DataFrame;
        header,
        typemap,
        missingstrings,
        truestrings,
        falsestrings,
        kwargs...
    )
end

function column_name(ind, col_categorical, col_targets)
    ind == col_targets && return :targets
    type = in(ind, col_categorical) ? "cat" : "num"
    return Symbol("$(type)$(ind)")
end

function csv_data(
    N::Type{<:Name},
    path,
    type::Symbol;
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
        insertcols!(table, 1, :targets => y)
    end

    # save
    save_raw(N, path, type, table)
    return
end

function csv_add_targets(
    N::Type{<:Name},
    path,
    type::Symbol;
    col_targets::Int = 0,
    pos_labels = [],
    kwargs...
)

    table = load_raw(N, key)
    targets = csvread(path; kwargs...)[:, col_targets]
    if !isempty(pos_labels)
        targets = data_binarize(targets, pos_labels)
    end
    insertcols!(table, 1, :targets => targets)

    # save
    save_raw(N, path, type, table)
    return
end


# postprocessing
function postprocess(format::TabularData, data::AbstractDataFrame)
    if format.asmatrix
        y = data.targets
        x = select(data, Not(:targets))
        return Array(x), y
    else
        return data
    end
end
