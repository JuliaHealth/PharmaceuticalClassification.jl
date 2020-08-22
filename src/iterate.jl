import MetaGraphs

@inline function Base.iterate(graph::PharmGraph)
    iteration = Base.iterate(MetaGraphs.vertices(graph.g))
    vertex_integer, next_state = iteration
    class = _vertex_integer_to_class(graph, vertex_integer)
    result = (class, next_state)
    return result
end

@inline function Base.iterate(graph::PharmGraph, state)
    iteration = Base.iterate(MetaGraphs.vertices(graph.g), state)
    iteration === nothing && return nothing
    vertex_integer, next_state = iteration
    class = _vertex_integer_to_class(graph, vertex_integer)
    result = (class, next_state)
    return result
end

@inline function Base.IteratorSize(::Type{PharmGraph})
    return Base.HasLength()
end

@inline function Base.IteratorEltype(::Type{PharmGraph})
    return Base.HasEltype()
end

@inline function Base.eltype(::Type{PharmGraph})
    return PharmClass
end

@inline function Base.length(graph::PharmGraph)
    return MetaGraphs.nv(graph.g)
end
