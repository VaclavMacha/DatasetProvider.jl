abstract type Classification <: Task end

struct TwoClass <: Classification end
struct MultiClass <: Classification end

# partition by classes
partition_size(targets, at) = partition_size(targets, [at...,])

function partition_size(targets, at::AbstractVector)
    n = StatsBase.counts(targets)
    ns = round.(Int, n .* at')
    return [ns n .- sum(ns, dims = 2)]
end

function targets_map(targets)
    classes = sort(unique(targets))
    mapping = Dict(tuple.(classes, 1:length(classes)))
    return y -> mapping[y]
end

targets_map(::BitArray) = y -> y ? 2 : 1

function partition(::Dataset{N, F, T}, targets, at) where {N, F, T<:Classification}
    ymap = targets_map(targets)
    ns = partition_size(ymap.(targets), at)

    parts = zeros.(Int, sum(ns; dims = 1))
    class_part = ones(Int, size(ns, 1))
    class_count = zero(class_part)
    pos_part = ones(Int, size(ns, 2))

    for (ind, y) in pairs(targets)
        class = ymap(y)

        count_max = ns[class, class_part[class]]
        if class_count[class] == count_max
            class_count[class] = 1
            class_part[class] += 1
        else
            class_count[class] += 1
        end

        i = class_part[class]
        parts[i][pos_part[i]] = ind
        pos_part[i] += 1
    end
    return Tuple(parts)
end