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

const all_neighbors = MetaGraphs.all_neighbors
const inneighbors = MetaGraphs.inneighbors
const outneighbors = MetaGraphs.outneighbors

include("types.jl")

include("build.jl")
include("countlines.jl")
include("edge.jl")
include("iterate.jl")
include("normalize.jl")
include("system.jl")
include("traversal.jl")
include("vertex.jl")

end
