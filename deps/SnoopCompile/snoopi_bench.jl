using SnoopCompile

botconfig = BotConfig(
  "MusicXML";
  os = ["linux", "windows", "macos"],
  version = [v"1.4.1", v"1.3.1", v"1.2.0"],
  blacklist = [],
  exhaustive = false,
)


println("Benchmarking the inference time of `using MusicXML`")
snoopi_bench(
  botconfig,
  :(using MusicXML),
)


println("Benchmarking the inference time of `using MusicXML` & basic function test")
snoopi_bench(
  botconfig,
  "$(@__DIR__)/example_script.jl",
)
