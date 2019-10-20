developing = true; # are you developing the package or just using?
if developing
# ] add Revise # if you don't have it
    path = pwd()
    if path[end-7:end] != "MusicXML"
        error("cd(to the MusicXML path)")
    end
    push!(LOAD_PATH, ".")
    using Revise
    using MusicXML
else
    using MusicXML
end
################################################################

data = readmusicxml(joinpath("examples", "musescore.musicxml"))
