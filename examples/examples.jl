# ]dev path_to_MusicXML.j
using Revise
using MusicXML

################################################################

data = readmusicxml(joinpath("examples", "musescore.musicxml"))
