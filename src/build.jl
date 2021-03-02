@inline function new_graph(::Type{I}, ::Type{F}) where I where F
    g = MetaGraphs.MetaDiGraph{I, F}()
    MetaGraphs.set_indexing_prop!(g, :class)
    return PharmGraph{I, F}(g)
end

@inline function build_graph(; kwargs...)
    config = Config(; kwargs...)
    return build_graph(config)
end

@inline function build_graph(config::Config)
    graph = new_graph(Int64, Float64)
    return build_graph!(graph::PharmGraph, config::Config)
end

@inline function build_graph!(graph::PharmGraph, config::Config)
    all_filenames = [
        config.rxnrel,
        config.rxnsat,
    ]
    all_numlines = countlines_filename.(all_filenames)
    total_numlines = sum(all_numlines)
    showprogress::Bool = config.showprogress
    wait_time = showprogress ? Float64(1.0) : Float64(Inf)
    p = ProgressMeter.Progress(total_numlines + 10, wait_time)

    open(config.rxnsat, "r") do io
        for line in eachline(io)
            ProgressMeter.next!(p;
                showvalues = [
                    (:Stage, "1 of 3"),
                    (:File, "RXNSAT.RRF"),
                ],
            )
            elements = split(line, "|")
            left_system = "RXCUI"
            left_value = elements[1]
            RIGHT_SYSTEM_TYPE = elements[9]
            if RIGHT_SYSTEM_TYPE == "NDC"
                add_right_node = true
                edges = :bidirectional
                right_system = "NDC"
                right_value = elements[11]
            elseif RIGHT_SYSTEM_TYPE == "ATC_LEVEL"
                add_right_node = true
                edges = :right_to_left
                right_system = string(elements[10], elements[11])
                right_value = elements[6]
            else
                add_right_node = false
            end
            left_node = PharmClass(left_system, left_value)
            PharmaceuticalClassification._add_edge!(graph, left_node => left_node)
            if add_right_node
                right_node = PharmClass(right_system, right_value)
                PharmaceuticalClassification._add_edge!(graph, right_node => right_node)
                if edges == :left_to_right || edges == :bidirectional
                    PharmaceuticalClassification._add_edge!(graph, left_node => right_node)
                end
                if edges == :right_to_left || edges == :bidirectional
                    PharmaceuticalClassification._add_edge!(graph, right_node => left_node)
                end
            end
        end
    end

    ProgressMeter.next!(p;
        showvalues = [
            (:Stage, "2 of 3"),
            (:Description, "Add edges for ATC hierarchy"),
        ],
    )
    add_atc_hierarchy_edges!(graph)

    open(config.rxnrel, "r") do io
        for line in eachline(io)
            ProgressMeter.next!(p;
                showvalues = [
                    (:Stage, "3 of 3"),
                    (:File, "RXNREL.RRF"),
                ],
            )
            elements = split(line, "|")
            if elements[11] == "RXNORM" && elements[3] == "CUI" && elements[7] == "CUI"
                relationship = elements[8]
                if relationship == "consists_of" || relationship == "has_ingredient"
                    more_specific_rxcui = elements[5]
                    element_1 = elements[1]
                    if occursin(":", element_1)
                        less_specific_rxcui = split(element_1, ':')[2]
                    else
                        less_specific_rxcui = element_1
                    end
                    more_specific_node = PharmClass("RXCUI", more_specific_rxcui)
                    less_specific_node = PharmClass("RXCUI", less_specific_rxcui)
                    PharmaceuticalClassification._add_edge!(graph, less_specific_node => more_specific_node)
                end
            end
        end
    end

    ProgressMeter.finish!(p)

    return graph
end
