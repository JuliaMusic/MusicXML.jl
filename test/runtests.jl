using MusicXML
using Test

cd(@__DIR__)

@testset "parsing example" begin
    include("../examples/parsing.jl")
    @test scorepartwise isa MX.ScorePartwise
    @test scoreparts isa Vector{MX.ScorePart}
    @test parts isa Vector{MX.Part}
end

@testset "creating example" begin
    include("../examples/creating.jl")
    @test isfile("../examples/myscore.musicxml")
end

@testset "grace note" begin
    include("../examples/grace.jl")
end
