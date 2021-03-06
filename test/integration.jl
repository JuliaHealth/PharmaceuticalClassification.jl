@testset "Integration tests" begin
    @testset "Integration tests with synthetic data" begin
        in_temporary_directory() do
            rxnrel = "RXNREL.RRF"
            rxnsat = "RXNSAT.RRF"

            open(rxnrel, "w") do io
                generate_synthetic_rxnrel(io)
            end
            open(rxnsat, "w") do io
                generate_synthetic_rxnsat(io)
            end

            graph_built = build_graph(;
                showprogress = false,
                rxnrel,
                rxnsat,
            )
            my_filename_for_serialization = "my_filename.serialized"
            rm(my_filename_for_serialization; force = true, recursive = true)
            Serialization.serialize(my_filename_for_serialization, graph_built)
            graph_loaded_from_file = Serialization.deserialize(my_filename_for_serialization)
            for graph in [graph_built, graph_loaded_from_file]
                @test graph isa PharmGraph
                @test available_systems(graph) == ["ATC1", "ATC2", "ATC3", "ATC4", "ATC5", "NDC", "RXCUI"]
                @test haskey(graph, PharmClass("ATC5", "A01BC23"); normalization = true)
                @test haskey(graph, PharmClass("ATC5", "A01BC23"); normalization = false)
                @test graph[PharmClass("ATC5", "A01BC23")] == PharmClass("ATC5", "A01BC23")
                @test getindex(graph, PharmClass("ATC5", "A01BC23"); normalization = true) == PharmClass("ATC5", "A01BC23")
                @test getindex(graph, PharmClass("ATC5", "A01BC23"); normalization = false) == PharmClass("ATC5", "A01BC23")
                @test equivalent(graph, PharmClass("ATC5", "A01BC23"); normalization = true) == [PharmClass("ATC5", "A01BC23")]
                @test equivalent(graph, PharmClass("ATC5", "A01BC23"); normalization = false) == [PharmClass("ATC5", "A01BC23")]
                @test equivalent(graph, PharmClass("NDC", "12345678901")) == [PharmClass("NDC", "12345678901"), PharmClass("RXCUI", "1234567")]
                @test equivalent(graph, PharmClass("RXCUI", "1234567")) == [PharmClass("NDC", "12345678901"), PharmClass("RXCUI", "1234567")]
                @test parents(graph, PharmClass("ATC5", "A01BC23"); normalization = true) == PharmClass[PharmClass("ATC1", "A"), PharmClass("ATC2", "A01"), PharmClass("ATC3", "A01B"), PharmClass("ATC4", "A01BC"), PharmClass("ATC5", "A01BC23")]
                @test parents(graph, PharmClass("ATC5", "A01BC23"); normalization = false) == PharmClass[PharmClass("ATC1", "A"), PharmClass("ATC2", "A01"), PharmClass("ATC3", "A01B"), PharmClass("ATC4", "A01BC"), PharmClass("ATC5", "A01BC23")]
                @test parents(graph, PharmClass("NDC", "12345678901")) == PharmClass[PharmClass("ATC1", "A"), PharmClass("ATC2", "A01"), PharmClass("ATC3", "A01B"), PharmClass("ATC4", "A01BC"), PharmClass("ATC5", "A01BC23"), PharmClass("NDC", "12345678901"), PharmClass("RXCUI", "1234567")]
                @test parents(graph, PharmClass("RXCUI", "1234567")) == PharmClass[PharmClass("ATC1", "A"), PharmClass("ATC2", "A01"), PharmClass("ATC3", "A01B"), PharmClass("ATC4", "A01BC"), PharmClass("ATC5", "A01BC23"), PharmClass("NDC", "12345678901"), PharmClass("RXCUI", "1234567")]
                @test children(graph, PharmClass("ATC5", "A01BC23"); normalization = true) == [PharmClass("ATC5", "A01BC23"), PharmClass("NDC", "12345678901"), PharmClass("RXCUI", "1234567")]
                @test children(graph, PharmClass("ATC5", "A01BC23"); normalization = false) == [PharmClass("ATC5", "A01BC23"), PharmClass("NDC", "12345678901"), PharmClass("RXCUI", "1234567")]
                @test children(graph, PharmClass("NDC", "12345678901")) == [PharmClass("NDC", "12345678901"), PharmClass("RXCUI", "1234567")]
                @test children(graph, PharmClass("RXCUI", "1234567")) == [PharmClass("NDC", "12345678901"), PharmClass("RXCUI", "1234567")]
                @test all_neighbors(graph, PharmClass("ATC5", "A01BC23"); normalization = true) == PharmClass[PharmClass("ATC4", "A01BC"), PharmClass("ATC5", "A01BC23"), PharmClass("RXCUI", "1234567")]
                @test all_neighbors(graph, PharmClass("ATC5", "A01BC23"); normalization = false) == PharmClass[PharmClass("ATC4", "A01BC"), PharmClass("ATC5", "A01BC23"), PharmClass("RXCUI", "1234567")]
                @test inneighbors(graph, PharmClass("ATC5", "A01BC23"); normalization = true) == PharmClass[PharmClass("ATC4", "A01BC"), PharmClass("ATC5", "A01BC23")]
                @test inneighbors(graph, PharmClass("ATC5", "A01BC23"); normalization = false) == PharmClass[PharmClass("ATC4", "A01BC"), PharmClass("ATC5", "A01BC23")]
                @test outneighbors(graph, PharmClass("ATC5", "A01BC23"); normalization = true) == PharmClass[PharmClass("ATC5", "A01BC23"), PharmClass("RXCUI", "1234567")]
                @test outneighbors(graph, PharmClass("ATC5", "A01BC23"); normalization = false) == PharmClass[PharmClass("ATC5", "A01BC23"), PharmClass("RXCUI", "1234567")]
                a = sort(unique(all_neighbors(graph, PharmClass("ATC5", "A01BC23"))))
                b = sort(unique(inneighbors(graph, PharmClass("ATC5", "A01BC23"))))
                c = sort(unique(outneighbors(graph, PharmClass("ATC5", "A01BC23"))))
                @test a == sort(unique(vcat(b, c)))
                @test !issubset(a, b)
                @test issubset(b, a)
                @test issubset(c, a)
                @test !issubset(c, b)
                @test length(graph) == 9
                count = 0
                for node in graph
                    count += 1
                end
                @test count == length(graph)
                @test eltype(graph) == PharmClass
            end
        end
    end
end
