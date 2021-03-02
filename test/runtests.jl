using PharmaceuticalClassification
using Test

import Serialization

include("test_utils/generate-synthetic-data.jl")
include("test_utils/utils.jl")

@testset "PharmaceuticalClassification.jl" begin
    include("unit.jl")
    include("integration.jl")
end
