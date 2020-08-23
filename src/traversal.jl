import LightGraphs
import MetaGraphs

@inline function MetaGraphs.outneighbors(graph::PharmGraph,
                                         class::PharmClass;
                                         normalization::Bool = true)
    if normalization
        return _outneighbors(graph, normalize(class))
    else
        return _outneighbors(graph, class)
    end
end

@inline function _outneighbors(graph::PharmGraph, class::PharmClass)
    vert_int = _class_to_vertex_integer_nocreate(graph, class)
    outneighbors_vert_ints = MetaGraphs.outneighbors(graph.g, vert_int)
    outneighbors_classes = _vertex_integers_to_class(graph, outneighbors_vert_ints)
    unique!(outneighbors_classes)
    sort!(outneighbors_classes)
    return outneighbors_classes
end

@inline function MetaGraphs.inneighbors(graph::PharmGraph,
                                        class::PharmClass;
                                        normalization::Bool = true)
    if normalization
        return _inneighbors(graph, normalize(class))
    else
        return _inneighbors(graph, class)
    end
end

@inline function _inneighbors(graph::PharmGraph, class::PharmClass)
    vert_int = _class_to_vertex_integer_nocreate(graph, class)
    inneighbors_vert_ints = MetaGraphs.inneighbors(graph.g, vert_int)
    inneighbors_classes = _vertex_integers_to_class(graph, inneighbors_vert_ints)
    unique!(inneighbors_classes)
    sort!(inneighbors_classes)
    return inneighbors_classes
end

@inline function MetaGraphs.neighbors(graph::PharmGraph,
                                      class::PharmClass;
                                      normalization::Bool = true)
    if normalization
        return _neighbors(graph, normalize(class))
    else
        return _neighbors(graph, class)
    end
end

@inline function _all_neighbors(graph::PharmGraph, class::PharmClass)
    vert_int = _class_to_vertex_integer_nocreate(graph, class)
    allneighbors_vert_ints = MetaGraphs.all_neighbors(graph.g, vert_int)
    allneighbors_classes = _vertex_integers_to_class(graph, allneighbors_vert_ints)
    unique!(allneighbors_classes)
    sort!(allneighbors_classes)
    return allneighbors_classes
end

@inline function _locations_of_nonzero_entries(entries::AbstractVector{I}) where I <: Integer
    n::I = length(entries)
    bools = BitVector(undef, n)
    for i = 1:n
        entry = entries[i]
        if entry > 0
            bools[i] = true
        else
            bools[i] = false
        end
    end
    one_to_n::UnitRange{I} = I(1):I(n)
    result::Vector{I} = one_to_n[bools]
    return result
end

@inline function parents(graph::PharmGraph,
                         class::PharmClass;
                         normalization::Bool = true)
    if normalization
        return _parents(graph, normalize(class))
    else
        return _parents(graph, class)
    end
end

@inline function _parents(graph::PharmGraph, class::PharmClass)
    vert_int = _class_to_vertex_integer_nocreate(graph, class)
    _parents = LightGraphs.bfs_parents(graph.g.graph, vert_int; dir = :in)
    parent_vert_ints = _locations_of_nonzero_entries(_parents)
    classes = _vertex_integers_to_class(graph, parent_vert_ints)
    return classes
end

@inline function children(graph::PharmGraph,
                          class::PharmClass;
                          normalization::Bool = true)
    if normalization
        return _children(graph, normalize(class))
    else
        return _children(graph, class)
    end
end

@inline function _children(graph::PharmGraph, class::PharmClass)
    vert_int = _class_to_vertex_integer_nocreate(graph, class)
    _parents = LightGraphs.bfs_parents(graph.g.graph, vert_int; dir = :out)
    parent_vert_ints = _locations_of_nonzero_entries(_parents)
    classes = _vertex_integers_to_class(graph, parent_vert_ints)
    return classes
end

@inline function equivalent(graph::PharmGraph,
                            class::PharmClass;
                            normalization::Bool = true)
    if normalization
        return _equivalent(graph, normalize(class))
    else
        return _equivalent(graph, class)
    end
end

@inline function _equivalent(graph::PharmGraph, class::PharmClass)
    class_parents = _parents(graph, class)
    class_children = _children(graph, class)
    class_equivalent = intersect(class_parents, class_children)
    unique!(class_equivalent)
    sort!(class_equivalent)
    return class_equivalent
end
