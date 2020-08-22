@inline function normalize(class::PharmClass)
    system = class.system::String
    if system == "NDC"
        old_value = class.value::String
        new_value = _normalize_ndc(old_value)::String
        return PharmClass(system, new_value)
    else
        return class
    end
end

@inline function _normalize_ndc(old_ndc_value::String)
    return old_ndc_value
end
