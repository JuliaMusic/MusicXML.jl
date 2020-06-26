using SnoopCompile

botconfig = BotConfig(
  "MusicXML";
  yml_path = "SnoopCompile.yml"
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
