module MusicXML

using EzXML, MIDI, MusicManipulations
export readmusicxml, parsemusicxml

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
mutable struct scorepart
    ID::String      # e.g. P1
    name::String    # e.g. Violin
    midiinstrument::midiinstrument
end
################################################################
"""
    extractdata(doc)

Helper internal function which extract musicxml data. This function is not exported. Use readmusicxml and parsemusicxml instead.

# Examples
```julia
data = extractdata(doc)
```
"""
function extractdata(doc::EzXML.Document)

    # Get the root element from `doc`.
    scorepartwise = root(doc)

    if scorepartwise.name != "score-partwise"
        error("Only score-partwise musicxml files are supported")
    end

    # Score Partwise
    for scorepartwiseC in eachelement(scorepartwise)

        # Part List
        if scorepartwiseC.name == "part-list"
            partlist = scorepartwiseC

            scoreParts = Any[]

            iPart = 1
            for partlistC in eachelement(partlist)

                # TODO part-group

                # Score Part
                if partlistC.name == "score-part"

                    scorePartI = scorepart()

                    scorePartI.ID = partlistC["id"]

                    for scorepartC in eachelement(partlistC)
                        if scorepartC == "part-name"
                            scorePartI.name = scorepartC.content
                        end
                        # TODO score-instrument
                        # TODO midi-device
                        if scorepartC == "midi-instrument"
                            midiinstrumentI = midiinstrument()
                            # TODO scorepartC["id"]
                            midiinstrumentI.channel = findfirst("/midi-channel",scorepartC)
                            midiinstrumentI.program = findfirst("/midi-program",scorepartC)
                            midiinstrumentI.volume = findfirst("/volume",scorepartC)
                            midiinstrumentI.pan = findfirst("/pan", scorepartC)
                            scorePartI.midiinstrument = midiinstrumentI
                        end
                    end
                    push!(scoreParts, scorePartI)
                    iPart = +1
                end  # Score Part


            end
            data.scoreParts = scoreParts
        end # Part List


    end # Score Partwise


    return data
end
################################################################
"""
    readmusicxml(filepath)

Reads musicxml file and extracts the data.

# Examples
```julia
data = readmusicxml(joinpath("examples", "musescore.musicxml"))
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
