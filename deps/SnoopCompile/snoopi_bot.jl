using SnoopCompile

botconfig = BotConfig(
  "MusicXML";
  yml_path = "SnoopCompile.yml"
)

snoop_bot(
  botconfig,
  "$(@__DIR__)/example_script.jl",
)
