using SnoopCompile

@snoopi_bot "MusicXML" begin
  using MusicXML
  examplePath = joinpath(dirname(dirname(pathof(MusicXML))), "examples")
  include(joinpath(examplePath, "parsing.jl"))
end
