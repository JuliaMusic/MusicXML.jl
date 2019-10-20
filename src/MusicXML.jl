module MusicXML

using EzXML, MIDI, MusicManipulations

"""
    midiinstrument
    midiinstrument(midichannel, midiprogram, volume, pan)

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
    midichannel::UInt8 # 0 to 15
    midiprogram::UInt8
    volume::UInt8
    pan::Int8
end

"""
    part
    part(partID, partName, midiinstrument)

Holds information about one part in a score
# Examples
```julia
part("P1","Violin",midiinstrument(0,1,127,0))
```
"""
mutable struct part
    partID::String      # e.g. P1
    partName::String    # e.g. Violin
    midiinstrument::midiinstrument
end


end
