function merge_sort(a::AbstractVector, before::Function)
    n = length(a)
    n <= 1 && return collect(a)

    mid = div(n, 2)
    left = merge_sort(a[1:mid], before)
    right = merge_sort(a[mid+1:n], before)

    result = eltype(a)[]
    i = 1
    j = 1

    while i <= length(left) && j <= length(right)
        if before(left[i], right[j]) || !before(right[j], left[i])
            push!(result, left[i])
            i += 1
        else
            push!(result, right[j])
            j += 1
        end
    end

    append!(result, left[i:end])
    append!(result, right[j:end])
    return result
end

v = [3, 1, 2]
ket_qua = merge_sort(v, isless)
println(ket_qua)
