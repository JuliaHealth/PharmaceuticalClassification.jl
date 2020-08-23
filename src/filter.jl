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
