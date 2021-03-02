@inline function available_systems(graph::PharmGraph)
    all_systems_set = Set{String}()

    function f(class)
        system = class.system::String
        push!(all_systems_set, system)
        return nothing
    end

    _for_each_node(f, graph)

    all_systems_vector = collect(all_systems_set)
    unique!(all_systems_vector)
    sort!(all_systems_vector)
    return all_systems_vector
end

@inline function system_matches(class::PharmClass, system::String)
    class_system = class.system::String
    return class_system == system
end

@inline function system_matches(class::PharmClass, system::Regex)
    class_system = class.system::String
    return occursin(system, class_system)
end

@inline function system_matches(system::String)
     function _system_matches(class::PharmClass)
         class_system = class.system::String
         return class_system == system
     end
     return _system_matches
end

@inline function system_matches(system::Regex)
    function _system_matches(class::PharmClass)
        class_system = class.system::String
        return occursin(system, class_system)
    end
    return _system_matches
end
