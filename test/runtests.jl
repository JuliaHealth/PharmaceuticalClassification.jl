using PharmaceuticalClassification
using Test

import Documenter
import Serialization

include("generate-synthetic-data.jl")

original_directory = pwd()

@testset "PharmaceuticalClassification.jl" begin
    @testset "Unit tests" begin
    end

    @testset "Integration tests" begin
        @testset "Integration tests with synthetic data" begin
            in_temporary_directory() do
                rxnsat = "RXNSAT.RRF"
                rm(rxnsat; force = true, recursive = true)
                @test !ispath(rxnsat)
                @test !isfile(rxnsat)
                open(rxnsat, "w") do io
                    generate_synthetic_rxnsat(io)
                end
                @test ispath(rxnsat)
                @test isfile(rxnsat)
                graph_built = build_graph(; showprogress = false, rxnsat = rxnsat)
                my_filename_for_serialization = "my_filename.serialized"
                rm(my_filename_for_serialization; force = true, recursive = true)
                @test !ispath(my_filename_for_serialization)
                @test !isfile(my_filename_for_serialization)
                Serialization.serialize(my_filename_for_serialization, graph_built)
                @test ispath(my_filename_for_serialization)
                @test isfile(my_filename_for_serialization)
                graph_loaded_from_file = Serialization.deserialize(my_filename_for_serialization)
                for graph in [graph_built, graph_loaded_from_file]
                    @test graph isa PharmGraph
                    @test available_systems(graph; showprogress = false) == ["ATC5", "NDC", "RXCUI"]
                    @test equivalent(graph, PharmClass("ATC5", "A01BC23")) == [PharmClass("ATC5", "A01BC23")]
                    @test equivalent(graph, PharmClass("NDC", "12345678901")) == [PharmClass("NDC", "12345678901"), PharmClass("RXCUI", "1234567")]
                    @test equivalent(graph, PharmClass("RXCUI", "1234567")) == [PharmClass("NDC", "12345678901"), PharmClass("RXCUI", "1234567")]
                    @test parents(graph, PharmClass("ATC5", "A01BC23")) == [PharmClass("ATC5", "A01BC23")]
                    @test parents(graph, PharmClass("NDC", "12345678901")) == [PharmClass("ATC5", "A01BC23"), PharmClass("NDC", "12345678901"), PharmClass("RXCUI", "1234567")]
                    @test parents(graph, PharmClass("RXCUI", "1234567")) == [PharmClass("ATC5", "A01BC23"), PharmClass("NDC", "12345678901"), PharmClass("RXCUI", "1234567")]
                    @test children(graph, PharmClass("ATC5", "A01BC23")) == [PharmClass("ATC5", "A01BC23"), PharmClass("NDC", "12345678901"), PharmClass("RXCUI", "1234567")]
                    @test children(graph, PharmClass("NDC", "12345678901")) == [PharmClass("NDC", "12345678901"), PharmClass("RXCUI", "1234567")]
                    @test children(graph, PharmClass("RXCUI", "1234567")) == [PharmClass("NDC", "12345678901"), PharmClass("RXCUI", "1234567")]
                    @test length(graph) == 3
                    count = 0
                    for node in graph
                        count += 1
                    end
                    @test count == length(graph)
                    @test count == 3
                end
            end
        end
    end

    @testset "Doctests" begin
        Documenter.doctest(PharmaceuticalClassification)
    end
end

cd(original_directory)
