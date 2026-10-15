struct Order
    id::Int
    benefit::Int
end

function knapsack(orders, costs, budget)
    budget >= 0 || throw(ArgumentError("Ngan sach khong duoc am."))

    n = length(orders)
    table = zeros(Int, n + 1, budget + 1)

    for i in 1:n
        order = orders[i]
        1 <= order.id <= length(costs) ||
            throw(ArgumentError("ID don hang khong hop le: $(order.id)"))
        order.benefit >= 0 ||
            throw(ArgumentError("Loi ich don hang khong duoc am."))
        cost = costs[order.id]
        cost >= 0 || throw(ArgumentError("Chi phi khong duoc am."))

        for b in 0:budget
            table[i + 1, b + 1] = table[i, b + 1]

            if cost <= b
                take_value = table[i, b - cost + 1] + order.benefit

                if take_value > table[i + 1, b + 1]
                    table[i + 1, b + 1] = take_value
                end
            end
        end
    end

    ids = Int[]
    b = budget

    for i in n:-1:1
        if table[i + 1, b + 1] > table[i, b + 1]
            push!(ids, orders[i].id)
            b -= costs[orders[i].id]
        end
    end

    reverse!(ids)
    total_cost = sum((costs[id] for id in ids); init=0)

    return (
        ids=ids,
        value=table[n + 1, budget + 1],
        cost=total_cost,
        table=table
    )
end

orders = [
    Order(1, 6),
    Order(2, 8),
    Order(3, 10)
]
costs = [3, 5, 6]  
budget = 8

result = knapsack(orders, costs, budget)
println("ID don duoc chon: ", result.ids)
println("Tong chi phi: ", result.cost)
println("Tong loi ich: ", result.value)
println("Bang quy hoach dong:")
show(stdout, "text/plain", result.table)
println()