using MusicXML
using Test

cd(@__DIR__)

@testset "parsing example" begin
    include("../examples/parsing.jl")
    @test scorepartwise isa ScorePartwise
    @test scprts isa Vector{ScorePart}
    @test prts isa Vector{Part}
end

@testset "creating example" begin
    include("../examples/creating.jl")
    @test isfile("../examples/myscore.musicxml")
end
