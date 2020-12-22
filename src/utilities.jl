"""
    concretesubtypes(T::Type)

Returns an array of all concrete subtypes of the given type `T`.
"""
function concretesubtypes(T::Type)
    isabstracttype(T) || return DataType[]
    types = map(subtypes(T)) do S
        return isabstracttype(S) ? concretesubtypes(S) : S
    end
    return reduce(vcat, types)
end

"""
    remove(N::Type{<:Name})

Removes given dataset `N`, if installed.
"""
function remove(N::Type{<:Name})
    path = DataDeps.try_determine_load_path("$(nameof(N))", @__DIR__)
    if !isnothing(path)
        rm(path; recursive = true)
        printstyled(" ✖ $(nameof(N)) dataset removed \n"; color = :red)
    end
    return
end

"""
    removeall()

Removes all downloaded datasets.
"""
function removeall()
    if DataDeps.input_bool("Do you want to remove all downloaded datasets?")
        remove.(concretesubtypes(Name))
    end
    return
end

"""
    listdatasets()

Prints the names of all available datasets and highlights datasets that have already been downloaded. Datasets are sorted into groups based on their problem type and format type.
"""
function listdatasets()
    Ns = concretesubtypes(Name)
    Ps = subtypes(Problem)
    Fs = subtypes(Format)

    for P in Ps
        isabstracttype(P) && continue
        printstyled("$(nameof(P)): \n"; color = :blue, bold = true)
        for F in Fs
            isabstracttype(F) && continue
            datasets = [D for D in Ns if problemtype(D) <: P && formattype(D) <: F]
            isempty(datasets) && continue
            printstyled("  $(nameof(F)): \n"; color = :yellow, bold = true)
            for D in datasets
                path = DataDeps.try_determine_load_path("$(nameof(D))", @__DIR__)
                if isnothing(path)
                    printstyled("    ✖ $(nameof(D)) \n"; color = :red)
                else
                    printstyled("    ✔ $(nameof(D)) \n"; color = :green, bold = true)
                end
            end
        end
    end
    return
end
