using SnoopCompile

botconfig = BotConfig(
  "MusicXML";
  os = ["linux", "windows", "macos"],
  version = [v"1.4.1"],
  blacklist = [],
  exhaustive = false,
)


println("Benchmarking the inference time of `using MusicXML`")
snoop_bench(
  botconfig,
  :(using MusicXML),
)


println("Benchmarking the inference time of `using MusicXML` & basic function test")
snoop_bench(
  botconfig,
  "$(@__DIR__)/example_script.jl",
)
