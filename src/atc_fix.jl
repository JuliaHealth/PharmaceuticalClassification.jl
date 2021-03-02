function _get_all_atc_nodes(graph::PharmGraph)
    all_atc_nodes_set = Vector{PharmClass}(undef, 0)

    function f(class)
        system = class.system::String
        if startswith(system, "ATC")
            push!(all_atc_nodes_set, class)
        end
        return nothing
    end

    _for_each_node(f, graph)

    all_atc_nodes_vector = collect(all_atc_nodes_set)
    unique!(all_atc_nodes_vector)
    sort!(all_atc_nodes_vector)
    return all_atc_nodes_vector
end

function add_atc_hierarchy_edges!(graph::PharmGraph)
    all_atc_levels = _get_all_atc_nodes(graph)

    all_atc1 = Vector{PharmClass}(undef, 0)
    all_atc2 = Vector{PharmClass}(undef, 0)
    all_atc3 = Vector{PharmClass}(undef, 0)
    all_atc4 = Vector{PharmClass}(undef, 0)
    all_atc5 = Vector{PharmClass}(undef, 0)

    for x in all_atc_levels
        system = x.system
        if system == "ATC1"
            push!(all_atc1, x)
        elseif system == "ATC2"
            push!(all_atc2, x)
        elseif system == "ATC3"
            push!(all_atc3, x)
        elseif system == "ATC4"
            push!(all_atc4, x)
        elseif system == "ATC5"
            push!(all_atc5, x)
        end
    end

    unique!(all_atc1)
    unique!(all_atc2)
    unique!(all_atc3)
    unique!(all_atc4)
    unique!(all_atc5)

    sort!(all_atc1)
    sort!(all_atc2)
    sort!(all_atc3)
    sort!(all_atc4)
    sort!(all_atc5)

    atc = [all_atc1, all_atc2, all_atc3, all_atc4, all_atc5]

    for i in 1:4
        atc_i        = atc[i]
        atc_iplusone = atc[i + 1]
        for less_specific_node in atc_i
            for more_specific_node in atc_iplusone
                if startswith(more_specific_node.value, less_specific_node.value)
                    PharmaceuticalClassification._add_edge!(
                        graph,
                        less_specific_node => more_specific_node,
                    )
                end
            end
        end
    end

    return nothing
end
