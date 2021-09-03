struct TabularData <: Format end

samplesdim(::Type{TabularData}) = 1
saveformat(::Type{TabularData}) = "csv"
saveraw(::Type{TabularData}, path, data) = CSV.write(path, data)
loadraw(::Type{TabularData}, path) = CSV.read(path, DataFrame; header = true)

function args(
    ::Type{TabularData};
    asmatrix = false,
    origheader = false,
    kwargs...
)

    return (; asmatrix, origheader)
end

# meta data 
colname(::Type) = "col"
colname(::Type{<:Union{Missing, Real}}) = "real"
colname(::Type{<:Union{Missing, AbstractString}}) = "str"
colname(::Type{<:Union{Missing, Date}}) = "date"

function compute_pad(key, colnames)
    c = count(==(key), colnames)
    return c == 1 ? 0 : ndigits(c)
end

function add_pad(key, i, pad)
    if pad == 0
        return key
    else
        return string(key, "_", lpad(i, pad, "0"))
    end
end

function compute_meta(
    ::Type{TabularData},
    table::AbstractDataFrame,
    istarget,
    iscategorical,
    toremove
)   

    if !(isa(istarget, Int) || length(istarget) == 1 || isempty(istarget))  
        throw(ArgumentError("only one target vector is supported"))
    end

    n = size(table, 2)
    inds = setdiff(1:n, reduce(vcat, [istarget, iscategorical, toremove]))
    types = [colname(eltype(table[!, i])) for i in inds]
    types_prm = sortperm(types)

    # column permutation
    prm = reduce(vcat, [istarget, iscategorical, inds[types_prm]])
    header = vcat(
        fill("targets", length(istarget))...,
        fill("cat", length(iscategorical))...,
        types[types_prm]...
    )
    col_pad = Dict(key => compute_pad(key, header) for key in unique(header))
    counter = Dict{String, Int}()
    
    header = map(header) do key 
        i = get!(counter, key, 1)
        counter[key] += 1
        return add_pad(key, i, col_pad[key])
    end

    return Dict(
        :header => header,
        :header_original => names(table)[prm],
        :permutation => prm,
    )
end

# csv utilities
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

function load_excel(file, sheet)
    error("Loading excel files is not supported by default.")
end

function preprocess_csv(
    N::Type{<:Name},
    path,
    type::Symbol;
    istarget = Int[],
    iscategorical = Int[],
    toremove = Int[],
    header = false,
    excel::Bool = false,
    sheetname::String = "Sheet1",
    kwargs...
)

    # read table and metadata
    table = if excel
        DataFrame(load_excel(path, sheetname))
    else
        csvread(path; header, kwargs...)
    end
    if hasmeta(N)
        meta = loadmeta(N)
    else
        meta = compute_meta(TabularData, table, istarget, iscategorical, toremove)
        savemeta(N, meta)
    end

    # rename and remove columns
    rename!(table, Pair.(meta[:header_original], meta[:header]))
    select!(table, meta[:header])

    # save
    saveraw(N, path, type, table)
    return
end

function preprocess_targets(
    N::Type{<:Name},
    path,
    type::Symbol;
    istarget::Int = 1,
    kwargs...
)

    table = loadraw(N, type)
    insertcols!(table, 1, "targets" => csvread(path; kwargs...)[:, istarget])

    # save
    saveraw(N, path, type, table)
    return
end


# postprocessing
function postprocess(
    N::Type{<:Name},
    ::Type{<:TabularData},
    table::AbstractDataFrame;
    asmatrix,
    origheader,
    kwargs...
    )
    
    table = copy(table)
    if asmatrix
        y = table.targets |> Vector
        x = select(table, Not(:targets)) |> Array
        return x, y
    else
        meta = loadmeta(N)
        origheader && rename!(table, Pair.(meta[:header], meta[:header_original]))
        return table
    end
end
