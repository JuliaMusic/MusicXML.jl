using MusicXML

exampledir = joinpath(dirname(dirname(@__DIR__)), "examples")

include("$exampledir/parsing.jl")
include("$exampledir/creating.jl")
