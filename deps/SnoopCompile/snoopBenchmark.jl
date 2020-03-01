using SnoopCompile

@snoopi_bench "MusicXML" begin
  using MusicXML
  examplePath = joinpath(dirname(dirname(pathof(MusicXML))), "examples")
  include(joinpath(examplePath, "parsing.jl"))
end
