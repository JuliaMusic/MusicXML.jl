module MusicXML

using EzXML
import EzXML.Node

import MIDI, MusicManipulations

# I/O functions
export readmusicxml, parsemusicxml
# Types:
export MusicXML, Part, Measure, Note, Unpitched, Rest, Pitch, Attributes, Time, Transpose, Clef, Key, Partlist, Scorepart, Midiinstrument, Mididevice, Scoreinstrument
# Utilities
export pitch2xml, xml2pitch
# XML utilities
export findfirstcontent, findallcontent

# overloading nothing (not recommended):
Base.getproperty(::Nothing, sym::Symbol) = nothing
# Base.getproperty(::Nothing, sym::Symbol) = sym === :content ? nothing : Core.getfield(nothing, sym)
################################################################
"""
    findfirstcontent(element,node)
    findfirstcontent(type,element,node)


Returns first element content. It also convert to the desired format by passing type. element is given as string.
```julia
findfirstcontent("/instrument-name",node)
findfirstcontent(UInt8,"/midi-channel",node)
```
"""
function findfirstcontent(s::String,node::Node)
    elm = findfirst(s,node)
    if isnothing(elm)
        return nothing
    else
        return elm.content
    end
end

function findfirstcontent(::Type{T},s::String,node::Node) where {T}
    elm = findfirst(s,node)
    if isnothing(elm)
        return nothing
    else
        return parse(T, elm.content)
    end
end

################################################################
"""
    findallcontent(type, string, node)

Finds all the elements with the address of string in the node, and converts the elements to Type object.
"""
function findallcontent(::Type{T}, s::String, node::Node) where{T}

    elmsNode = findall(s, node) # a vector of Node elements
    if isnothing(elmsNode)
        return nothing
    else
        elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
        i=1
        for elm in elmsNode
            elmsType[i]=T(elm)
            i=+1
        end
        return elmsType
    end

end
################################################################
"""
    Scoreinstrument

...
# Arguments
- name::String
- ID::String
- xml::Node
...

The score-instrument type represents a single instrument within a score-part. As with the score-part type, each score-instrument has a required ID attribute, a name, and an optional abbreviation. A score-instrument type is also required if the score specifies MIDI 1.0 channels, banks, or programs. An initial midi-instrument assignment can also be made here. MusicXML software should be able to automatically assign reasonable channels and instruments without these elements in simple cases, such as where part names match General MIDI instrument names.
"""
mutable struct Scoreinstrument
    name::String
    ID::String
    xml::Node
end

# xml constructor
function Scoreinstrument(name,ID)
    xml = ElementNode("score-instrument")
    addelement!(xml, "instrument-name", string(name))
    xml["id"] = ID * "-I1"
    return Scoreinstrument(name, ID, xml)
end

# xml extractor
function Scoreinstrument(xml::Node)

    name = findfirstcontent("/instrument-name",xml)
    ID = xml["id"][end-3:end]
    return Scoreinstrument(name, ID, xml)
end
Scoreinstrument(x::Scoreinstrument) = Scoreinstrument(x.xml)

Scoreinstrument(n::Nothing) = nothing
################################################################
"""
    Mididevice

...
# Arguments
- port::Int16
- ID::String
- xml::Node
...

The midi-device type corresponds to the DeviceName meta event in Standard MIDI Files. Unlike the DeviceName meta event, there can be multiple midi-device elements per MusicXML part starting in MusicXML 3.0.
"""
mutable struct Mididevice
    port::Int16
    ID::String
    xml::Node
end

# xml constructor
function Mididevice(port,ID)
    xml = ElementNode("midi-device")
    xml["port"] = string(port)
    xml["id"] = ID * "-I1"
    return Mididevice(port, ID, xml)
end

# xml extractor
function Mididevice(xml::Node)
    port = parse(Int16, xml["port"])
    ID = xml["id"][end-3:end]
    return Mididevice(port, ID, xml)
end
Mididevice(x::Mididevice) = Mididevice(x.xml)

Mididevice(n::Nothing) = nothing
################################################################
"""
    Midiinstrument

...
# Arguments
- channel::UInt8 # 0 to 15
- program::UInt8
- volume::UInt8
- pan::Int8
- ID::String
- xml::Node
...

Midiinstrument type holds information about the sound of a midi instrument.

# http://www.music-software-development.com/midi-tutorial.html - Part 4
# Status byte : 1100 CCCC
# Data byte 1 : 0XXX XXXX

# Examples
```julia
Midiinstrument(0,1,127,0)
```
"""
mutable struct Midiinstrument
    channel::UInt8 # 0 to 15
    program::UInt8
    volume::UInt8
    pan::Int8
    ID::String
    xml::Node
end

# default constructor
# Midiinstrument() = Midiinstrument(0, 1, 127, 0, "P1")
# Midiinstrument(channel, program, volume, pan) = Midiinstrument(channel, program, volume, pan, "P1")

# xml constructor
function Midiinstrument(channel, program, volume, pan, ID)
    xml = ElementNode("midi-instrument")
    addelement!(xml, "midi-channel", string(channel))
    addelement!(xml, "midi-program", string(program))
    addelement!(xml, "volume", string(volume))
    addelement!(xml, "pan", string(pan))
    xml["id"] = ID * "-I1"
    return Midiinstrument(channel, program, volume, pan, ID, xml)
end

# xml extractor
function Midiinstrument(xml::Node)

    channel = findfirstcontent(UInt8, "/midi-channel",xml)
    program = findfirstcontent(UInt8, "/midi-program",xml)
    volume = findfirstcontent(UInt8, "/volume",xml)
    pan = findfirstcontent(UInt8, "/pan",xml)
    ID = xml["id"][end-3:end]
    return Midiinstrument(channel, program, volume, pan, ID, xml)
end
Midiinstrument(x::Midiinstrument) = Midiinstrument(x.xml)

Midiinstrument(n::Nothing) = nothing
################################################################
"""
    Scorepart

...
# Arguments
- name::String
- scoreinstrument::Union{Nothing,Scoreinstrument}
- mididevice::Union{Nothing,Mididevice}
- midiinstrument::Midiinstrument
- ID::String
- xml::Node
...

Holds information about one Scorepart in a score

Each MusicXML part corresponds to a track in a Standard MIDI Format 1 file. The score-instrument elements are used when there are multiple instruments per track. The midi-device element is used to make a MIDI device or port assignment for the given track or specific MIDI instruments. Initial midi-instrument assignments may be made here as well.

scoreinstrument: See [`ScoreInstrument`](@ref) doc
mididevice: See [`Mididevice`](@ref) doc
midiinstrument: See [`Midiinstrument`](@ref) doc


[More info](https://usermanuals.musicxml.com/MusicXML/Content/CT-MusicXML-score-part.htm)

# Examples
```julia
Scorepart(name = "Violin",midiinstrument = midiinstrument(0,1,127,0), ID = "P1")
```
"""
mutable struct Scorepart
    name::String
    scoreinstrument::Union{Nothing,Scoreinstrument}
    mididevice::Union{Nothing,Mididevice}
    midiinstrument::Midiinstrument
    ID::String
    xml::Node
end

# default constructor
# Scorepart() = Scorepart(name = "Piano", midiinstrument = midiinstrument(), ID = "P1")

# xml constructor
function Scorepart(; name, scoreinstrument = nothing, mididevice = nothing, midiinstrument, ID)
    xml = ElementNode("score-part")
    addelement!(xml, "part-name", string(name))
    if !isnothing(scoreinstrument)  addelement!(xml, "score-instrument", scoreinstrument) end
    if !isnothing(mididevice) addelement!(xml, "midi-device", mididevice) end
    addelement!(xml, "midi-instrument", string(midiinstrument))
    xml["id"] = string(ID)
    return Scorepart(name, scoreinstrument, mididevice, midiinstrument, ID, xml)
end

# xml extractor
function Scorepart(xml::Node)

    name = findfirstcontent("/part-name",xml)
    scoreinstrument = Scoreinstrument(findfirst("/score-instrument", xml))
    mididevice = Mididevice(findfirst("/midi-device", xml))
    midiinstrument = Midiinstrument(findfirst("/midi-instrument", xml))
    ID = xml["id"]
    return Scorepart(name, scoreinstrument, mididevice, midiinstrument, ID, xml)
end
Scorepart(x::Scorepart) = Scorepart(x.xml)

Scorepart(n::Nothing) = nothing
################################################################
"""
    Partlist

...
# Arguments
- # TODO partgroup
- scoreparts::Vector{Scorepart}
- xml::Node
...

Holds scoreparts and partgroup.

See [`Scorepart`](@ref) doc

"""
mutable struct Partlist
    # TODO partgroup
    scoreparts::Vector{Scorepart}
    xml::Node
end

# xml constructor
function Partlist(scoreparts::Vector{Scorepart})
    xml = ElementNode("part-list")
    numScoreparts = length(scoreparts)
    for i = 1:numScoreparts
        addelement!(xml, "score-part", scoreparts[i])
    end
    return Partlist(scoreparts, xml)
end

# xml extractor
function Partlist(xml::Node)

    scoreparts = findallcontent(Scorepart,"/score-part", xml)
    isnothing(scoreparts) ? Partlist(nothing) : Partlist(scoreparts, xml)
end
Partlist(x::Partlist) = Partlist(x.xml)

Partlist(n::Nothing) = nothing
################################################################
"""
    Key

...
# Arguments
- fifth::Int8
- mode::Union{Nothing,String}
- xml::Node
...

A type to hold key information for a measure in musicxml file.

The key element represents a key signature. Both traditional and non-traditional key signatures are supported. The optional number attribute refers to staff numbers. If absent, the key signature applies to all staves in the part.

fifth: number of flats or sharps in a traditional key signature. Negative numbers are used for flats and positive numbers for sharps, reflecting the key's placement within the circle of fifths

mode:  major, minor, dorian, phrygian, lydian, mixolydian, aeolian, ionian, locrian, none

[More info](https://usermanuals.musicxml.com/MusicXML/Content/CT-MusicXML-key.htm)
"""
mutable struct Key
    fifth::Int8
    mode::Union{Nothing,String}
    xml::Node
end

# xml constructor
function Key(; fifth, mode = nothing)
    xml = ElementNode("key")
    addelement!(xml, "fifths", string(fifth))
    if !isnothing(mode) addelement!(xml, "mode", mode) end
    return Key(fifth, mode, xml)
end

# xml extractor
function Key(xml::Node)
    fifth = findfirstcontent(Int8, "/fifth", xml)
    mode = findfirstcontent("/mode", xml)
    return Key(fifth, mode, xml)
end
Key(x::Key) = Key(x.xml)

Key(n::Nothing) = nothing
################################################################
"""
    Clef

...
# Arguments
- sign::String
- line::Int16
- xml::Node
...

A type to hold clef information for a measure in musicxml file.

Clefs are represented by a combination of sign, line, and clef-octave-change elements. Clefs appear at the start of each system unless the print-object attribute has been set to "no" or the additional attribute has been set to "yes".

sign: The sign element represents the clef symbol: G, F, C, percussion, TAB, jianpu, none. [More info](https://usermanuals.musicxml.com/MusicXML/Content/ST-MusicXML-clef-sign.htm)

line: Line numbers are counted from the bottom of the staff. Standard values are 2 for the G sign (treble clef), 4 for the F sign (bass clef), 3 for the C sign (alto clef) and 5 for TAB (on a 6-line staff).

[More info](https://usermanuals.musicxml.com/MusicXML/Content/CT-MusicXML-clef.htm)
"""
mutable struct Clef
    sign::String
    line::Int16
    xml::Node
end

# xml constructor
function Clef(sign, line)
    xml = ElementNode("clef")
    addelement!(xml, "sign", sign)
    addelement!(xml, "line", string(line))
    return Clef(sign, line, xml)
end

# xml extractor
function Clef(xml::Node)

    sign = findfirstcontent("/sign", xml)
    line = findfirstcontent(Int16, "/line", xml)
    return Clef(sign, line, xml)
end
Clef(x::Clef) = Clef(x.xml)

Clef(n::Nothing) = nothing
################################################################
"""
    Transpose

...
# Arguments
- diatonic::Int8
- chromatic::Int8
- octaveChange::Union{Nothing,Int8}
- double::Union{Nothing,Bool}
- xml::Node
...

A type to hold transpose information for a measure in musicxml file.

If the part is being encoded for a transposing instrument in written vs. concert pitch, the transposition must be encoded in the transpose element using the transpose type.

diatonic: The diatonic element specifies the number of pitch steps needed to go from written to sounding pitch. This allows for correct spelling of enharmonic transpositions.

chromatic: The chromatic element represents the number of semitones needed to get from written to sounding pitch. This value does not include octave-change values; the values for both elements need to be added to the written pitch to get the correct sounding pitc

octaveChange: The octave-change element indicates how many octaves to add to get from written pitch to sounding pitch.

double: If the double element is present, it indicates that the music is doubled one octave down from what is currently written (as is the case for mixed cello / bass parts in orchestral literature).

[More info](https://usermanuals.musicxml.com/MusicXML/Content/EL-MusicXML-transpose.htm)
"""
mutable struct Transpose
    diatonic::Int8
    chromatic::Int8
    octaveChange::Union{Nothing,Int8}
    double::Union{Nothing,Bool}
    xml::Node
end

# xml constructor
function Transpose(;diatonic=0, chromatic=0, octaveChange=nothing, double=nothing)
    xml = ElementNode("transpose")
    addelement!(xml, "diatonic", string(diatonic))
    addelement!(xml, "chromatic", string(chromatic))
    if !isnothing(octaveChange) addelement!(xml, "octave-change", octaveChange) end
    if !isnothing(double) addelement!(xml, "double", double) end
    return Transpose(diatonic, chromatic, octaveChange, double, xml)
end

# xml extractor
function Transpose(xml::Node)

    diatonic = findfirstcontent(Int8, "/diatonic", xml)
    chromatic = findfirstcontent(Int8, "/chromatic", xml)
    octaveChange = findfirstcontent(Int8, "/octave-change", xml)
    double = findfirstcontent("/double", xml)

    return Transpose(diatonic, chromatic, octaveChange, double, xml)
end
Transpose(x::Transpose) = Transpose(x.xml)

Transpose(n::Nothing) = nothing
################################################################
"""
    Time

...
# Arguments
- signature::Array{Int8,1}
- xml::Node
...

Time signatures are represented by the beats element for the numerator and the beat-type element for the denominator.
"""
mutable struct Time
    signature::Array{Int8,1}
    xml::Node
end

# default constructor
# Time() = Time([4,4])

# xml constructor
function Time(signature::Array{Int8,1})
    xml = ElementNode("time")
    addelement!(xml, "beats", string(signature[1]))
    addelement!(xml, "beat-type", string(signature[2]))
    return Time(signature, xml)
end

# xml extractor
function Time(xml::Node)

    signature = [4, 4]
    signature[1] = findfirstcontent(Int8, "/beats", xml)
    signature[2] = findfirstcontent(Int8, "/beat-type", xml)

    return Time(signature, xml)
end
Time(x::Time) = Time(x.xml)

Time(n::Nothing) = nothing
################################################################
"""
    Attributes

...
# Arguments
- divisions::Int16
- key::Key
- time::Time
- staves::Union{Nothing, UInt16}
- instruments::Union{Nothing,UInt16}
- clef::Union{Nothing,Clef}
- transpose::Union{Nothing,Transpose}
- xml::Node
...

A type to hold the data for the attributes of a musicxml measure

The attributes element contains musical information that typically changes on measure boundaries. This includes key and time signatures, clefs, transpositions, and staving. When attributes are changed mid-measure, it affects the music in score order, not in MusicXML document order.

key: See [`Key`](@ref) doc

divisions: Musical notation duration is commonly represented as fractions. The divisions element indicates how many divisions per quarter note are used to indicate a note's duration. For example, if duration = 1 and divisions = 2, this is an eighth note duration. Duration and divisions are used directly for generating sound output, so they must be chosen to take tuplets into account. Using a divisions element lets us use just one number to represent a duration for each note in the score, while retaining the full power of a fractional representation. If maximum compatibility with Standard MIDI 1.0 files is important, do not have the divisions value exceed 16383.

time: See [`Time`](@ref) doc

staves: The staves element is used if there is more than one staff represented in the given part (e.g., 2 staves for typical piano parts). If absent, a value of 1 is assumed. Staves are ordered from top to bottom in a part in numerical order, with staff 1 above staff 2.

instruments: The instruments element is only used if more than one instrument is represented in the part (e.g., oboe I and II where they play together most of the time). If absent, a value of 1 is assumed.

clef: See [`Clef`](@ref) doc

[More info](https://usermanuals.musicxml.com/MusicXML/Content/EL-MusicXML-attributes.htm)
"""
mutable struct Attributes
    divisions::Int16
    key::Key
    time::Time
    staves::Union{Nothing, UInt16}
    instruments::Union{Nothing,UInt16}
    clef::Union{Nothing,Clef}
    transpose::Union{Nothing,Transpose}
    xml::Node
end

# xml constructor
function Attributes(;divisions, key, time, staves = nothing, instruments = nothing, clef = nothing, transpose = nothing)
    xml = ElementNode("transpose")
    addelement!(xml, "divisions", string(divisions))
    addelement!(xml, "key", key)
    addelement!(xml, "time", time)
    if !isnothing(staves) addelement!(xml, "staves", staves) end
    if !isnothing(instruments) addelement!(xml, "instruments", instruments) end
    if !isnothing(clef) addelement!(xml, "clef", clef) end
    if !isnothing(transpose) addelement!(xml, "transpose", transpose) end
    return Attributes(divisions, key, time, staves, instruments, clef, transpose, xml)
end

# xml extractor
function Attributes(xml::Node)

    divisions = findfirstcontent(Int16, "/divisions", xml)
    key = Key(findfirst("/key", xml))
    time = Time(findfirst("/time", xml))
    staves = findfirstcontent(UInt16, "/staves", xml)
    instruments = findfirstcontent(UInt16, "/instruments", xml)
    clef = Clef(findfirst("/clef", xml))
    transpose = Transpose(findfirst("/transpose", xml))

    return Attributes(divisions, key, time, staves, instruments, clef, transpose, xml)
end
Attributes(x::Attributes) = Attributes(x.xml)

Attributes(n::Nothing) = nothing
################################################################
using Base.Meta, Base.Unicode
const PITCH_TO_NAME = Dict(
0=>"C", 1=>"C♯", 2=>"D", 3=>"D♯", 4=>"E", 5=>"F", 6=>"F♯", 7=>"G", 8=>"G♯", 9=>"A",
10 =>"A♯", 11=>"B")
const SHARPS = [1, 3, 6, 8, 10]
const NAME_TO_PITCH = Dict(
v => k for (v, k) in zip(values(PITCH_TO_NAME), keys(PITCH_TO_NAME)))

"""
    pitch2xml(pitch)

Return the musicxmls values of the given pitch

Modified from MIDI.jl
"""
function pitch2xml(j)
    i = Int(j)
    # TODO: microtonals
    rem = mod(i, 12)
    notename = PITCH_TO_NAME[rem]

    if rem in SHARPS
        step = notename[1]
        alter = 1 # using sharps by default (this is only for sound)
    else
        step = notename
        alter = 0
    end

    octave = (i÷12)-1
    return step, alter, octave
end
################################################################
"""
    xml2pitch(step, alter, octave) -> Int
Return the pitch value of the given note

Modified from MIDI.jl
"""
function xml2pitch(step, alter, octave)

    pitch = NAME_TO_PITCH[step]

    return pitch + alter + 12(octave+1) # lowest possible octave is -1 but pitch starts from 0
end
################################################################
"""
    Pitch
...
# Arguments
- pitch::UInt8  # midi pitch
- step::String
- alter::Float16
- octave::Int8
- xml::Node
...

Holds both midi pitch and musicxml pitch data. MusicXML pitch data is represented as a combination of the step of the diatonic scale, the chromatic alteration, and the octave.
"""
mutable struct Pitch
    pitch::UInt8  # midi pitch
    step::String
    alter::Float16
    octave::Int8
    xml::Node
end

# xml constructor
function Pitch(;pitch)
    xml = ElementNode("pitch")

    step, alter, octave = pitch2xml(pitch)

    addelement!(xml, "step", step)
    addelement!(xml, "alter", string(alter))
    addelement!(xml, "octave", string(octave))

    return Pitch(pitch, step, alter, octave, xml)
end

# xml extractor
function Pitch(xml::Node)

    step = findfirstcontent("/step", xml)
    alter = findfirstcontent(Float16,"/alter", xml)
    octave = findfirstcontent(Int8,"/octave", xml)

    pitch = xml2pitch(step, alter, octave)

    return Pitch(pitch = pitch, step = step, alter = alter, octave = octave, xml = xml)
end
Pitch(x::Pitch) = Pitch(x.xml)

Pitch(n::Nothing) = nothing
################################################################
"""
    Rest

...
# Arguments
- rest::Bool
- xml::Node
...

The rest element indicates notated rests or silences. Rest elements are usually empty, but placement on the staff can be specified using display-step and display-octave elements. If the measure attribute is set to yes, this indicates this is a complete measure rest.
"""
mutable struct Rest
    rest::Bool
    xml::Node
end

# xml constructor
function Rest(rest)
    if unpitched
        xml = ElementNode("rest")
    else
        xml = nothing
    end
    return Rest(rest, xml)
end

# xml extractor
function Rest(xml::Node)

    rest = xml.name == "rest"

    return Rest(rest, xml)
end
Rest(x::Rest) = Rest(x.xml)

Rest(n::Nothing) = nothing
################################################################
"""
    Unpitched

...
# Arguments
- unpitched::Bool
- xml::Node
...

The unpitched type represents musical elements that are notated on the staff but lack definite pitch, such as unpitched percussion and speaking voice.
"""
mutable struct Unpitched
    unpitched::Bool
    xml::Node
end

# xml constructor
function Unpitched(unpitched)
    if unpitched
        xml = ElementNode("unpitched")
    else
        xml = nothing
    end
    return Unpitched(unpitched, xml)
end

# xml extractor
function Unpitched(xml::Node)

    unpitched = xml.name == "unpitched"

    return Unpitched(rest, xml)
end
Unpitched(x::Unpitched) = Unpitched(x.xml)

Unpitched(n::Nothing) = nothing
################################################################
"""
    Note

...
# Arguments
- pitch::Pitch
- rest::Rest
- unpitched::Unpitched
- duration::UInt
- # voice
- type::String
- accidental::String
- # tie::Union{Nothing,Tie} # start, stop, nothing TODO
- # TODO lyric
- xml::Node
...

Notes are the most common type of MusicXML data. The MusicXML format keeps the MuseData distinction between elements used for sound information and elements used for notation information (e.g., tie is used for sound, tied for notation). Thus grace notes do not have a duration element. Cue notes have a duration element, as do forward elements, but no tie elements. Having these two types of information available can make interchange considerably easier, as some programs handle one type of information much more readily than the other.

pitch: See [`Pitch`](@ref) doc

duration : See [`MIDI.Note`] (@ref) doc

type: Type indicates the graphic note type, Valid values (from shortest to longest) are 1024th, 512th, 256th, 128th, 64th, 32nd, 16th, eighth, quarter, half, whole, breve, long, and maxima. The size attribute indicates full, cue, or large size, with full the default for regular notes and cue the default for cue and grace notes.

accidental: The accidental type represents actual notated accidentals. Editorial and cautionary indications are indicated by attributes. Values for these attributes are "no" if not present. Specific graphic display such as parentheses, brackets, and size are controlled by the level-display attribute group. Empty accidental objects are not allowed. If no accidental is desired, it should be omitted. sharp, flat, natural, double sharp, double flat, parenthesized accidental

tie:

[More info](https://usermanuals.musicxml.com/MusicXML/Content/CT-MusicXML-note.htm)
"""
mutable struct Note
    pitch::Pitch
    rest::Rest
    unpitched::Unpitched
    duration::UInt
    # voice
    type::String
    accidental::String
    # tie::Union{Nothing,Tie} # start, stop, nothing TODO
    # TODO lyric
    xml::Node
end

# xml constructor
function Note(;pitch = nothing, rest = nothing, unpitched = nothing, duration, type = nothing, accidental = nothing)
    xml = ElementNode("note")

    if pitch != nothing
        addelement!(xml, "pitch", pitch)
    elseif rest != nothing
        addelement!(xml, "rest", rest)
    elseif unpitched != nothing
        addelement!(xml, "unpitched", unpitched)
    else
        error("one of the pitch, rest or unpitched should be given")
    end

    addelement!(xml, "duration", string(duration))
    if !isnothing(type) addelement!(xml, "type", type) end
    if !isnothing(accidental) addelement!(xml, "accidental", accidental) end
    # tie == nothing ?  : addelement!(xml, "tie", tie)

    return Note(pitch, rest, unpitched, duration, type, accidental, xml)
end

# xml extractor
function Note(xml::Node)

    pitch = Pitch(findfirst("/pitch", xml))
    rest = Rest(findfirst("/rest", xml))
    unpitched = Unpitched(findfirst("/unpitched", xml))
    duration = findfirstcontent(UInt,"/duration", xml)
    type = findfirstcontent("/type", xml)
    accidental = findfirstcontent("/accidental", xml)

    return Note(pitch, rest, unpitched, duration, type, accidental, xml)
end
Note(x::Note) = Note(x.xml)

Note(n::Nothing) = nothing
################################################################
"""
    Measure

...
# Arguments
- attributes::Union{Nothing,Attributes}
- notes::Vector{Note}
- xml::Node
...


A type to hold the data for a musicxml measure

attributes: See [`Attributes`](@ref) doc
notes: See [`Note`](@ref) doc

"""
mutable struct Measure
    attributes::Union{Nothing,Attributes}
    notes::Vector{Note}
    xml::Node
end

# xml constructor
function Measure(;attributes = nothing, notes)
    xml = ElementNode("measure")

    if !isnothing(attributes) addelement!(xml, "attributes", attributes) end

    numNotes = length(notes)
    for i = 1:numNotes
        addelement!(xml, "note", notes[i])
    end
    return Measure(attributes, notes, xml)
end

# xml extractor
function Measure(xml::Node)

    attributes = Attributes(findfirst("/attributes", xml))

    notes = findallcontent(Note,"/note", xml)
    isnothing(notes) ? Measure(nothing) : Measure(attributes, notes, xml)

end
Measure(x::Measure) = Measure(x.xml)

Measure(n::Nothing) = nothing
################################################################
"""
    Part

...
# Arguments
- measures::Vector{Measure}
- ID::String
- xml::Node
...

A type to hold the data for a part in musicxml file.

measures: See [`Measure`](@ref) doc

"""
mutable struct Part
    measures::Vector{Measure}
    ID::String
    xml::Node
end

# xml constructor
function Part(measures, ID)
    xml = ElementNode("part")

    numMeasures = length(measures)
    for i = 1:numMeasures
        addelement!(xml, "measure", measures[i])
    end
    xml["id"] = ID
    return Part(measures, ID, xml)
end

# xml extractor
function Part(xml::Node)

     ID = xml["id"]
    measures = findallcontent(Measure,"/measure", xml)
    isnothing(measures) ? Part(nothing) : Part(measures, ID, xml)
end
Part(x::Part) = Part(x.xml)

Part(n::Nothing) = nothing
################################################################
"""
    Musicxml

A type to hold the data for a musicxml file.
"""
mutable struct Musicxml
    # TODO identification
    # TODO defaults
    partlist::Partlist
    parts::Vector{Part}
    xml::Node
end

# xml constructor
function Musicxml(partlist, parts)
    xml = ElementNode("score-partwise")

    addelement!(xml, "part-list", measures[i])

    numParts = length(parts)
    for i = 1:numParts
        addelement!(xml, "part", parts[i])
    end
    return Musicxml(partlist, parts, xml)
end

# xml extractor
function Musicxml(xml::Node)

    partlist = Partlist(findfirst("part-list", xml))

    parts = findallcontent(Part,"/part", xml)
    isnothing(parts) ? Musicxml(nothing) : Musicxml(partlist, parts, xml)

end
Musicxml(x::Musicxml) = Musicxml(x.xml)

Musicxml(n::Nothing) = nothing
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

    musicxml = Musicxml(scorepartwise)
    partlist = Partlist(musicxml.partlist)
    parts = Part.(musicxml.parts)

    # for part in parts
    #     measures = Measure.(part.measures)
    # end
    return partlist, parts
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
