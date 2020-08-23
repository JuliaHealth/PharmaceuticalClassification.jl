@inline function add_edge!(graph::PharmGraph,
                           pair::Pair{PharmClass,PharmClass};
                           normalization::Bool = true)
    if normalization
        from_class = pair[1]::PharmClass
        to_class = pair[2]::PharmClass
        normalized_pair = normalize(from_class) => normalize(to_class)
        _add_edge!(graph, normalized_pair)
    else
        _add_edge!(graph, pair)
    end
    return nothing
end

@inline function _add_edge!(graph::PharmGraph,
                            pair::Pair{PharmClass,PharmClass})
    g = graph.g
    from_class = pair[1]
    to_class = pair[2]
    from_vertex_integer = _class_to_vertex_integer!(graph, from_class)
    to_vertex_integer = _class_to_vertex_integer!(graph, to_class)
    MetaGraphs.add_edge!(g, from_vertex_integer, to_vertex_integer)
    return nothing
end
