struct TabularData <: Format end

function args(
    ::Type{TabularData};
    asmatrix = false,
    origheader = false,
    kwargs...
)

    return (; asmatrix, origheader)
end

obsdim(::Type{TabularData}) = 1
saveformat(::Type{TabularData}) = "csv"
saveraw(::Type{TabularData}, path, data) = CSV.write(path, data)
loadraw(::Type{TabularData}, path) = CSV.read(path, DataFrame; header = true)


# csv read
function csvread(
    path;
    header = false,
    missingstrings = ["", "NA", "?", "*", "#DIV/0!"],
    truestrings = ["T", "t", "TRUE", "true", "y", "yes"],
    falsestrings = ["F", "f", "FALSE", "false", "n", "no"],
    gzip::Bool = false,
    kwargs...
)
    file = gzip ? transcode(GzipDecompressor, Mmap.mmap(path)) : path

    return CSV.read(
        file,
        DataFrame;
        header,
        missingstrings,
        truestrings,
        falsestrings,
        kwargs...
    )
end

# column rename
colname(::Type{<:Union{Missing, AbstractFloat}}) = "real"
colname(::Type{<:Union{Missing, Integer}}) = "int"
colname(::Type{<:Union{Missing, AbstractString}}) = "str"

function makeunique!(names::Vector{<:String})
    pad = Dict(key => ndigits(sum(names .== key)) for key in unique(names))
    count = Dict{String, Int}()
    for i in eachindex(names)
        key = names[i]
        names[i] = string(key, "_", lpad(get!(count, key, 1), pad[key], "0"))
        count[key] += 1
    end
    return
end

function colnames(df::AbstractDataFrame, categorical, targets, toremove)
    col_names = names(df)
    for (i, name) in enumerate(col_names)
        if in(i, toremove)
            col_names[i] = "rm"
        elseif in(i, targets)
            col_names[i] = "target"
        elseif in(i, categorical)
            col_names[i] = "cat"
        else
            col_names[i] = colname(eltype(getproperty(df, name)))
        end
    end
    makeunique!(col_names)
    return col_names
end

function preprocess(
    name::Name{},
    path,
    type::Symbol;
    categorical = Int[],
    toremove = Int[],
    targets = Int[],
    pos_labels = [],
    header = false,
    kwargs...
)

    df = csvread(path; header, kwargs...)
    rename!(df, colnames(df, categorical, targets, toremove))

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
    CSV.write(path, data)
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

    table = load_raw(N, type)
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
