import MetaGraphs
import ProgressMeter

@inline function available_systems(graph::PharmGraph;
                                   showprogress::Bool = true)
    all_systems = Set{String}()
    num_vertices = length(MetaGraphs.vertices(graph.g))
    wait_time::Float64 = showprogress ? Float64(1.0) : Float64(Inf)
    p = ProgressMeter.Progress(num_vertices, wait_time)
    for vertex_integer in MetaGraphs.vertices(graph.g)
        ProgressMeter.next!(p)
        class = _vertex_integer_to_class(graph, vertex_integer)::PharmClass
        system = class.system::String
        push!(all_systems, system)
    end
    result = collect(all_systems)
    unique!(result)
    sort!(result)
    return result
end
