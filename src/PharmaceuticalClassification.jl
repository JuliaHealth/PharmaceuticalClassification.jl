module PharmaceuticalClassification

import LightGraphs
import MetaGraphs
import ProgressMeter

export PharmClass
export PharmGraph
export all_neighbors
export available_systems
export build_graph
export build_graph!
export children
export equivalent
export inneighbors
export normalize
export outneighbors
export parents
export system_matches
export vertices

const inneighbors = MetaGraphs.inneighbors
const neighbors = MetaGraphs.neighbors
const outneighbors = MetaGraphs.outneighbors

include("types.jl")

include("available-systems.jl")
include("build.jl")
include("countlines.jl")
include("edge.jl")
include("filter.jl")
include("iterate.jl")
include("normalize.jl")
include("traversal.jl")
include("vertex.jl")

end
