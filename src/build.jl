import MetaGraphs
import ProgressMeter

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
    total_numlines = 0
    rxnsat = config.rxnsat::String
    rxnsat_abspath = abspath(rxnsat)
    rxnsat_numlines = countlines_filename(rxnsat_abspath)
    total_numlines += rxnsat_numlines
    showprogress::Bool = config.showprogress
    wait_time::Float64 = showprogress ? Float64(1.0) : Float64(Inf)
    p = ProgressMeter.Progress(total_numlines, wait_time)
    g = graph.g
    open(rxnsat_abspath, "r") do io
        for line in eachline(io)
            ProgressMeter.next!(p)
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
    return graph
end
