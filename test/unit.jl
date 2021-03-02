@testset "Unit tests" begin
    @testset "iterate.jl" begin
        @test Base.IteratorSize(PharmGraph) == Base.HasLength()
        @test Base.IteratorEltype(PharmGraph) == Base.HasEltype()
    end

    @testset "system.jl" begin
        @test system_matches(PharmClass("foo", "1"), "foo")
        @test system_matches("foo")(PharmClass("foo", "1"))
        @test !system_matches(PharmClass("foo", ""), "bar")
        @test !system_matches("bar")(PharmClass("foo", ""))
        @test system_matches(PharmClass("foo", "1"), r"foo")
        @test system_matches(r"foo")(PharmClass("foo", "1"))
        @test !system_matches(PharmClass("foo", "1"), r"bar")
        @test !system_matches(r"bar")(PharmClass("foo", "1"))
    end

    @testset "types.jl" begin
        @test Base.isless(PharmClass("bar", "1"), PharmClass("foo", "1"))
        @test Base.isless(PharmClass("bar", "1"), PharmClass("bar", "2"))
    end
end
