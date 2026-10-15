struct Order
    id::Int
end

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

orders = [Order(1), Order(2), Order(3)]

ket_qua = binary_search(orders, 2)
if ket_qua === nothing
    println("Khong tim thay don hang")
else
    println("Tim thay don hang ID: ", ket_qua.id)
end

ket_qua_khong_co = binary_search(orders, 99)
if ket_qua_khong_co === nothing
    println("Khong tim thay don hang ID 99")
else
    println("Tim thay don hang ID: ", ket_qua_khong_co.id)
end
