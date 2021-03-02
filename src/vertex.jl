@inline function Base.haskey(graph::PharmGraph,
                             class::PharmClass;
                             normalization::Bool = true)
    if normalization
        return _haskey(graph, normalize(class))
    else
        return _haskey(graph, class)
    end
end

@inline function _haskey(graph::PharmGraph,
                         class::PharmClass)
    g = graph.g
    return haskey(g.metaindex[:class], class)
end

@inline function Base.getindex(graph::PharmGraph,
                               class::PharmClass;
                               normalization::Bool = true)
    if normalization
        return _getindex(graph, normalize(class))
    else
        return _getindex(graph, class)
    end
end

@inline function _getindex(graph::PharmGraph,
                           class::PharmClass)
    vertex_integer = _class_to_vertex_integer_nocreate(graph, class)
    vertex_class = _vertex_integer_to_class(graph, vertex_integer)
    return vertex_class
end

@inline function _class_to_vertex_integer!(graph::PharmGraph,
                                           class::PharmClass)
    g = graph.g
    if !_haskey(graph, class)
        MetaGraphs.add_vertex!(g, :class, class)
    end
    return g[class, :class]
end

@inline function _class_to_vertex_integer_nocreate(graph::PharmGraph,
                                                   class::PharmClass)
    g = graph.g
    return g[class, :class]
end

@inline function _vertex_integer_to_class(graph::PharmGraph,
                                          vertex_integer::Integer)
    g = graph.g
    return g[vertex_integer, :class]
end

@inline function _vertex_integers_to_class(graph::PharmGraph,
                                           vertex_integers::AbstractVector{<:Integer})
    g = graph.g
    n = length(vertex_integers)
    classes = Vector{PharmClass}(undef, n)
    for i = 1:n
        vertex_integer = vertex_integers[i]
        class = _vertex_integer_to_class(graph, vertex_integer)
        classes[i] = class
    end
    unique!(classes)
    sort!(classes)
    return classes
end
