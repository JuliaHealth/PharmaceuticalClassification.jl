```@meta
CurrentModule = PharmaceuticalClassification
```

# Examples

## Generate graph and save graph to file
```julia
using PharmaceuticalClassification
using Serialization

rxnsat = "/path/to/rrf/RXNSAT.RRF"
graph = @time build_graph(; rxnsat = rxnsat) # usually takes approx 3-5 minutes
@time Serialization.serialize("my_graph_filename.serialized", graph) # usually takes approx 3-4 minutes
```

## Load graph from file
```julia
using PharmaceuticalClassification
using Serialization

graph = @time Serialization.deserialize("my_graph_filename.serialized") # usually takes approx 1-3 minutes
```

## Make queries
```julia
using PharmaceuticalClassification
using Serialization

graph = Serialization.deserialize("my_graph_filename.serialized")

available_systems(graph)
equivalent(graph, PharmClass("NDC", "1234-5678-90"))
parents(graph, PharmClass("NDC", "1234-5678-90"))
children(graph, PharmClass("NDC", "1234-5678-90"))

atc_vertices = PharmClass[]
p = ProgressMeter.Progress(length(graph), 1.0)
for vertex in graph
    ProgressMeter.next!(p)
    if system_matches(vertex, r"ATC")
        push!(atc_vertices, vertex)
    end
end
unique!(atc_vertices)
sort!(atc_vertices)
```
