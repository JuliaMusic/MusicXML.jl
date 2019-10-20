module MusicXML

using EzXML, MIDI, MusicManipulations

################################################################
"""
    midiinstrument
    midiinstrument(channel, program, volume, pan)

midiinstrument type holds information about the sound of a midi instrument.

# http://www.music-software-development.com/midi-tutorial.html - Part 4
# Status byte : 1100 CCCC
# Data byte 1 : 0XXX XXXX

# Examples
```julia
midiinstrument(0,1,127,0)
```
"""
mutable struct midiinstrument
    channel::UInt8 # 0 to 15
    program::UInt8
    volume::UInt8
    pan::Int8
end

"""
    part
    part(ID, name, midiinstrument)

Holds information about one part in a score
# Examples
```julia
part("P1","Violin",midiinstrument(0,1,127,0))
```
"""
mutable struct part
    ID::String      # e.g. P1
    name::String    # e.g. Violin
    midiinstrument::midiinstrument
end
################################################################

################################################################
"""
    readmusicxml(filepath)

Reads musicxml file and extracts the data.

# Examples
```julia
data = readxml(joinpath("examples", "musescore.musicxml"))
```
"""
function readmusicxml(filepath::String)
    doc = readxml(filepath) # read an XML document from a file
    data = extractdata(doc)
    return data
end
################################################################
"""
    parsemusicxml(s)

Parses musicxml from a string.

# Examples
```julia
data = parsemusicxml(s)
```
"""
function parsemusicxml(s::String)
    doc = parsexml(s) # Parse an XML string
    data = extractdata(doc)
    return data
end

end
