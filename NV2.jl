struct Order
    id::Int
    destination::Int
    service::Int
    benefit::Int
end

"""
    binary_search(a::Vector{Order}, id::Int)

Tim Order co ID bang `id`, hoac tra ve `nothing` neu khong tim thay.
Tien dieu kien: `a` da duoc sap xep tang dan theo `id` va ID la duy nhat.
"""
function binary_search(a::Vector{Order}, id::Int)
    lo = 1
    hi = length(a)

    while lo <= hi
        mid = lo + div(hi - lo, 2)
        current = a[mid]

        if current.id == id
            return current
        elseif current.id < id
            lo = mid + 1
        else
            hi = mid - 1
        end
    end

    return nothing
end

function binary_search_trace(a::Vector{Order}, id::Int)
    lo = 1
    hi = length(a)
    trace = NamedTuple[]

    while lo <= hi
        mid = lo + div(hi - lo, 2)
        current_id = a[mid].id

        if current_id == id
            push!(trace, (left=lo, mid=mid, right=hi,
                          current_id=current_id, action="tim thay"))
            return (result=a[mid], trace=trace)
        elseif current_id < id
            push!(trace, (left=lo, mid=mid, right=hi,
                          current_id=current_id, action="tim nua phai"))
            lo = mid + 1
        else
            push!(trace, (left=lo, mid=mid, right=hi,
                          current_id=current_id, action="tim nua trai"))
            hi = mid - 1
        end
    end

    return (result=nothing, trace=trace)
end

function print_trace(trace)
    println("left | mid | right | ID tai mid | Buoc")
    println("-----|-----|-------|------------|----------------")
    for row in trace
        println(lpad(string(row.left), 4), " | ",
                lpad(string(row.mid), 3), " | ",
                lpad(string(row.right), 5), " | ",
                lpad(string(row.current_id), 10), " | ", row.action)
    end
    isempty(trace) && println("Khong co buoc nao (danh sach rong).")
end

orders = [
    Order(1, 2, 1, 6),
    Order(2, 4, 1, 8),
    Order(3, 6, 1, 10)
]

println("Tim ID 2:")
result2 = binary_search_trace(orders, 2)
print_trace(result2.trace)
println("Ket qua: ", result2.result)

println("\nTim ID 99:")
result99 = binary_search_trace(orders, 99)
print_trace(result99.trace)
println("Ket qua: ", result99.result)

println("\nTim trong danh sach rong:")
empty_result = binary_search_trace(Order[], 2)
print_trace(empty_result.trace)
println("Ket qua: ", empty_result.result)

@assert binary_search(orders, 2).id == 2
@assert binary_search(orders, 99) === nothing
@assert binary_search(Order[], 2) === nothing

