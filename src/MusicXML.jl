module MusicXML

using AML

import MIDI, MusicManipulations

# I/O functions
export readmusicxml, parsemusicxml
# Types:
export MusicXML, Part, Measure, Note, Unpitched, Rest, Pitch, Attributes, Time, Transpose, Clef, Key, Partlist, Scorepart, Midiinstrument, Mididevice, Scoreinstrument
# Utilities
export pitch2xml, xml2pitch

################################################################
"""
    Scoreinstrument

# Arguments
- name::String
- ID::String
- xml::Node

The score-instrument type represents a single instrument within a score-part. As with the score-part type, each score-instrument has a required ID attribute, a name, and an optional abbreviation. A score-instrument type is also required if the score specifies MIDI 1.0 channels, banks, or programs. An initial midi-instrument assignment can also be made here. MusicXML software should be able to automatically assign reasonable channels and instruments without these elements in simple cases, such as where part names match General MIDI instrument names.
"""
@aml mutable struct Scoreinstrument "score-instrument"
    name::String, "instrument-name"
    ID::String, a"id"
end
################################################################
"""
    Mididevice

# Arguments
- port::Int16
- ID::String
- xml::Node

The midi-device type corresponds to the DeviceName meta event in Standard MIDI Files. Unlike the DeviceName meta event, there can be multiple midi-device elements per MusicXML part starting in MusicXML 3.0.
"""
@aml mutable struct Mididevice "midi-device"
    port::Int16, "port"
    ID::String, "id"
end
################################################################
"""
    Midiinstrument

# Arguments
- channel::UInt8 # 0 to 15
- program::UInt8
- volume::UInt8
- pan::Int8
- ID::String
- xml::Node

Midiinstrument type holds information about the sound of a midi instrument.

# http://www.music-software-development.com/midi-tutorial.html - Part 4
# Status byte : 1100 CCCC
# Data byte 1 : 0XXX XXXX

# Examples
```julia
Midiinstrument(0,1,127,0)
```
"""
@aml mutable struct Midiinstrument "midi-instrument"
    channel::UInt8 = 0, "midi-channel" # 0 to 15
    program::UInt8 = 1, "midi-program"
    volume::UInt8 = 127, "volume"
    pan::Int8 = 0, "pan"
    ID::String = "P1-I1", a"id"
end
################################################################
"""
    Scorepart

# Arguments
- name::String
- scoreinstrument::Union{Nothing,Scoreinstrument}
- mididevice::Union{Nothing,Mididevice}
- midiinstrument::Midiinstrument
- ID::String
- xml::Node

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
@aml mutable struct Scorepart "score-part"
    name::String, "part-name"
    scoreinstrument::Union{Nothing,Scoreinstrument} = nothing, "score-instrument"
    mididevice::Union{Nothing,Mididevice} = nothing, "midi-device"
    midiinstrument::Midiinstrument, "midi-instrument"
    ID::String, a"id"
end
################################################################
"""
    Partlist

# Arguments
- # TODO partgroup
- scoreparts::Vector{Scorepart}
- xml::Node

Holds scoreparts and partgroup.

See [`Scorepart`](@ref) doc

"""
@aml mutable struct Partlist "part-list"
    # TODO partgroup
    scoreparts::Vector{Scorepart}, "score-part"
end
################################################################
"""
    Key

# Arguments
- fifth::Int8
- mode::Union{Nothing,String}
- xml::Node

A type to hold key information for a measure in musicxml file.

The key element represents a key signature. Both traditional and non-traditional key signatures are supported. The optional number attribute refers to staff numbers. If absent, the key signature applies to all staves in the part.

fifth: number of flats or sharps in a traditional key signature. Negative numbers are used for flats and positive numbers for sharps, reflecting the key's placement within the circle of fifths

mode:  major, minor, dorian, phrygian, lydian, mixolydian, aeolian, ionian, locrian, none

[More info](https://usermanuals.musicxml.com/MusicXML/Content/CT-MusicXML-key.htm)
"""
@aml mutable struct Key "key"
    fifth::Int8, "fifths"
    mode::Union{Nothing,String} = nothing, "mode"
end
################################################################
"""
    Clef

# Arguments
- sign::String
- line::Int16
- xml::Node

A type to hold clef information for a measure in musicxml file.

Clefs are represented by a combination of sign, line, and clef-octave-change elements. Clefs appear at the start of each system unless the print-object attribute has been set to "no" or the additional attribute has been set to "yes".

sign: The sign element represents the clef symbol: G, F, C, percussion, TAB, jianpu, none. [More info](https://usermanuals.musicxml.com/MusicXML/Content/ST-MusicXML-clef-sign.htm)

line: Line numbers are counted from the bottom of the staff. Standard values are 2 for the G sign (treble clef), 4 for the F sign (bass clef), 3 for the C sign (alto clef) and 5 for TAB (on a 6-line staff).

[More info](https://usermanuals.musicxml.com/MusicXML/Content/CT-MusicXML-clef.htm)
"""
@aml mutable struct Clef "clef"
    sign::String, "sign"
    line::Int16, "line"
end
################################################################
"""
    Transpose

# Arguments
- diatonic::Int8
- chromatic::Int8
- octaveChange::Union{Nothing,Int8}
- double::Union{Nothing,Bool}
- xml::Node

A type to hold transpose information for a measure in musicxml file.

If the part is being encoded for a transposing instrument in written vs. concert pitch, the transposition must be encoded in the transpose element using the transpose type.

diatonic: The diatonic element specifies the number of pitch steps needed to go from written to sounding pitch. This allows for correct spelling of enharmonic transpositions.

chromatic: The chromatic element represents the number of semitones needed to get from written to sounding pitch. This value does not include octave-change values; the values for both elements need to be added to the written pitch to get the correct sounding pitc

octaveChange: The octave-change element indicates how many octaves to add to get from written pitch to sounding pitch.

double: If the double element is present, it indicates that the music is doubled one octave down from what is currently written (as is the case for mixed cello / bass parts in orchestral literature).

[More info](https://usermanuals.musicxml.com/MusicXML/Content/EL-MusicXML-transpose.htm)
"""
@aml mutable struct Transpose "transpose"
    diatonic::Int8 = 0, "diatonic"
    chromatic::Int8 = 0, "chromatic"
    octaveChange::Union{Nothing,Int8} = nothing, "octave-change"
    double::Union{Nothing,Bool} = nothing, "double"
end
################################################################
"""
    Time

# Arguments
- signature::Array{Int8,1}
- xml::Node

Time signatures are represented by the beats element for the numerator and the beat-type element for the denominator.
"""
@aml mutable struct Time, "time"
    beats::Int8 = 4, "beats"
    beattype::Int8 = 4, "beat-type"
end
################################################################
"""
    Attributes

# Arguments
- divisions::Int16
- key::Key
- time::Time
- staves::Union{Nothing, UInt16}
- instruments::Union{Nothing,UInt16}
- clef::Union{Nothing,Clef}
- transpose::Union{Nothing,Transpose}
- xml::Node

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
mutable struct Attributes, "attributes"
    divisions::Int16, "divisions"
    key::Key, "key"
    time::Time, "time"
    staves::Union{Nothing, UInt16} = nothing, "staves"
    instruments::Union{Nothing,UInt16} = nothing, "instruments"
    clef::Union{Nothing,Clef} = nothing, "clef"
    transpose::Union{Nothing,Transpose} = nothing, "transpose"
end
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

# Examples:
```julia
pitch = xml2pitch(step, alter, octave)
```
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

# Examples:
```julia
step, alter, octave = pitch2xml(pitch)
```
"""
function xml2pitch(step, alter, octave)

    pitch = NAME_TO_PITCH[step]

    return pitch + alter + 12(octave+1) # lowest possible octave is -1 but pitch starts from 0
end
################################################################
"""
    Pitch

# Arguments
- step::String
- alter::Float16
- octave::Int8
- xml::Node

Holds musicxml pitch data. MusicXML pitch data is represented as a combination of the step of the diatonic scale, the chromatic alteration, and the octave.

Use step, alter, octave = pitch2xml(pitch) and  pitch = xml2pitch(step, alter, octave)
for conversions between midi pitch and musicxml pitch

"""
@aml mutable struct Pitch "pitch"
    step::String, "step"
    alter::Float16, "alter"
    octave::Int8, "octave"
end
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

...
# Arguments
- # TODO identification
- # TODO defaults
- partlist::Partlist
- parts::Vector{Part}
- xml::Node
...


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
