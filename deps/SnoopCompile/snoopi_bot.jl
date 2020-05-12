using SnoopCompile

botconfig = BotConfig(
  "MusicXML";
  os = ["linux", "windows", "macos"],
  version = [v"1.4.1"],
  blacklist = [],
  exhaustive = false,
)

snoopi_bot(
  botconfig,
  "$(@__DIR__)/example_script.jl",
)
