struct PharmClass
    system::String
    value::String
end

@inline function Base.isless(x::PharmClass, y::PharmClass)
    x_system = x.system::String
    y_system = y.system::String
    if x_system == y_system
        x_value = x.value::String
        y_value = y.value::String
        return Base.isless(x_value, y_value)
    end
    return Base.isless(x_system, y_system)
end

struct PharmGraph{I, F}
    g::MetaGraphs.MetaDiGraph{I, F}
end

Base.@kwdef struct Config
    rxnrel::String
    rxnsat::String
    showprogress::Bool = true
end
