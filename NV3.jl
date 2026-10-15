mutable struct CircularQueue
    data::Vector{Int}
    head::Int
    tail::Int
    count::Int
end

CircularQueue(capacity::Int) = CircularQueue(zeros(Int, capacity), 1, 1, 0)

function enqueue!(queue::CircularQueue, value::Int)
    queue.count == length(queue.data) && error("Hang doi da day.")
    queue.data[queue.tail] = value
    queue.tail = queue.tail % length(queue.data) + 1
    queue.count += 1
    return queue
end

function dequeue!(queue::CircularQueue)
    queue.count == 0 && error("Hang doi dang rong.")
    value = queue.data[queue.head]
    queue.head = queue.head % length(queue.data) + 1
    queue.count -= 1
    return value
end

function bfs_routes(graph, source=1)
    n = length(graph)
    1 <= source <= n ||
        throw(ArgumentError("Dinh nguon khong hop le."))

    distance = fill(-1, n)
    parent = zeros(Int, n)
    queue = CircularQueue(n)

    distance[source] = 0
    enqueue!(queue, source)

    while queue.count > 0
        u = dequeue!(queue)

        for v in graph[u]
            if !(1 <= v <= n)
                throw(ArgumentError("Do thi chua dinh khong hop le: $v"))
            end

            if distance[v] == -1
                distance[v] = distance[u] + 1
                parent[v] = u
                enqueue!(queue, v)
            end
        end
    end

    routes = [Int[] for _ in 1:n]
    for destination in 1:n
        distance[destination] == -1 && continue

        path = Int[]
        v = destination
        while v != 0
            push!(path, v)
            v == source && break
            v = parent[v]
        end
        reverse!(path)
        routes[destination] = path
    end

    return (distance=distance, parent=parent, routes=routes)
end

graph = [
    [2, 3],
    [1, 4],
    [1, 5],
    [2, 6],
    [3, 6],
    [4, 5]
]

result = bfs_routes(graph, 1)
println("Khoang cach tu dinh 1: ", result.distance)
println("Cac duong di:")
for destination in eachindex(result.routes)
    if isempty(result.routes[destination])
        println("  Den dinh $destination: khong co duong di")
    else
        println("  Den dinh $destination: ", result.routes[destination])
    end
end