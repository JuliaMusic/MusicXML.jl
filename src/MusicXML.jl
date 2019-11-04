module MusicXML

using AcuteML

import MIDI, MusicManipulations

# I/O functions
export readmusicxml, parsemusicxml
# Types:
export Doc, Scorepartwise, Part, Measure, NoteX, Unpitched, Rest, Pitch, Attributes, Time, Transpose, Clef, Key, Partlist, Scorepart, Midiinstrument, Mididevice, Scoreinstrument
# Utilities
export pitch2xml, xml2pitch
################################################################
# musicxml yes-no type
struct YN
    yn::String
    bool::Bool

    function YN(bool::Bool)
        if bool
            yn = "yes"
        else
            yn = "no"
        end
        new(yn, bool)
    end

    function YN(yn::String)
        if yn == "yes"
            bool = true
        elseif yn == "no"
            bool = false
        end
        new(yn, bool)
    end

    function YN(yn::String, bool::Bool)
        if (yn == "yes" && bool == true) || (yn == "no" && bool == false)
            new(yn, bool)
        else
            error("invalid YN definition")
        end
    end
end
YN(::Nothing) = nothing
################################################################
# Common function checks
midi16(x) = 1<= x <= 16
midi128(x) = 1 <= x <= 128
midi16384(x) = 1 <= x <= 16384
percent(x) = 0 <= x <=100
rot180(x) = -180 <= x <= 180
positive(x) = x>0
################################################################
"""
    Scoreinstrument

# Arguments
```julia
- name::String, "instrument-name"
- abbreviation::UN{String} = nothing, "instrument-abbreviation"
- sound::UN{String} = nothing, "instrument-sound"
- # ensemble::UN{Int64} = nothing, sc"~", positive
- # solo::UN{Int64} = nothing, sc"~"
- id::String, a"id"
- # VST::VST, "virtual-instrument"
```
The score-instrument type represents a single instrument within a score-part. As with the score-part type, each score-instrument has a required id attribute, a name, and an optional abbreviation. A score-instrument type is also required if the score specifies MIDI 1.0 channels, banks, or programs. An initial midi-instrument assignment can also be made here. MusicXML software should be able to automatically assign reasonable channels and instruments without these elements in simple cases, such as where part names match General MIDI instrument names.

Refer to https://usermanuals.musicxml.com/MusicXML/Content/EL-MusicXML-score-instrument.htm.
"""
@macroexpand @aml mutable struct Scoreinstrument "score-instrument"
    name::String, "instrument-name"
    abbreviation::UN{String} = nothing, "instrument-abbreviation"
    sound::UN{String} = nothing, "instrument-sound"
    # ensemble::UN{Int64} = nothing, sc"~", positive
    # solo::UN{Int64} = nothing, sc"~"
    id::String, a"id"
    # VST::VST, "virtual-instrument"
end
################################################################
"""
    Mididevice

# Arguments
```julia
- port::Int16, a"port"
- id::String, a"id"
```
The midi-device type corresponds to the DeviceName meta event in Standard MIDI Files. Unlike the DeviceName meta event, there can be multiple midi-device elements per MusicXML part starting in MusicXML 3.0.

Refer to https://usermanuals.musicxml.com/MusicXML/Content/EL-MusicXML-midi-device.htm.
"""
@aml mutable struct Mididevice "midi-device"
    port::Int64, a"port", midi16
    id::String, a"id"
end
################################################################
"""
    Midiinstrument

# Arguments
```julia
- channel::Int64 = 0, "midi-channel",  midi16
- name::UN{String} = nothing, "midi-name"
- bank::UN{Int64} = nothing, "midi-bank", midi16384
- program::Int64 = 1, "midi-program", midiCheck
- unpitched::UN{Int64} = nothing, "midi-unpitched", midi16
- volume::Float64 = 127, "volume", percent
- pan::Float64 = 0, "pan", rot180
- elevation::UN{Float64} = nothing, "elevation", rot180
- id::String = "P1-I1", a"id"
```

Midiinstrument type holds information about the sound of a midi instrument.

Refer to https://usermanuals.musicxml.com/MusicXML/Content/EL-MusicXML-midi-instrument.htm

Pan: -90 is hard left, 0 is center, -180 is behind
"""
@aml mutable struct Midiinstrument "midi-instrument"
    channel::Int64 = 0, "midi-channel",  midi16
    name::UN{String} = nothing, "midi-name"
    bank::UN{Int64} = nothing, "midi-bank", midi16384
    program::Int64 = 1, "midi-program", midiCheck
    unpitched::UN{Int64} = nothing, "midi-unpitched", midi16
    volume::Float64 = 127, "volume", percent
    pan::Float64 = 0, "pan", rot180
    elevation::UN{Float64} = nothing, "elevation", rot180
    id::String = "P1-I1", a"id"
end
################################################################
"""
    Scorepart

# Arguments
```julia
- # identification
- name::String, "part-name"
- nameDisplay::UN{String} = nothing, "part-name-display"
- abbreviation::UN{String} = nothing, "part-abbreviation"
- abbreviationDisplay::UN{String} = nothing, "part-abbreviation-display"
- scoreinstrument::UN{Scoreinstrument} = nothing, "score-instrument"
- mididevice::UN{Mididevice} = nothing, "midi-device"
- midiinstrument::Midiinstrument, "midi-instrument"
- id::String, a"id"
```

Holds information about one Scorepart in a score

Each MusicXML part corresponds to a track in a Standard MIDI Format 1 file. The score-instrument elements are used when there are multiple instruments per track. The midi-device element is used to make a MIDI device or port assignment for the given track or specific MIDI instruments. Initial midi-instrument assignments may be made here as well.

scoreinstrument: See [`Scoreinstrument`](@ref) doc
mididevice: See [`Mididevice`](@ref) doc
midiinstrument: See [`Midiinstrument`](@ref) doc

[More info](https://usermanuals.musicxml.com/MusicXML/Content/CT-MusicXML-score-part.htm)

# Examples
```julia
Scorepart(name = "Violin",midiinstrument = Midiinstrument(), id = "P1")
```
"""
@aml mutable struct Scorepart "score-part"
    # identification
    name::String, "part-name"
    nameDisplay::UN{String} = nothing, "part-name-display"
    abbreviation::UN{String} = nothing, "part-abbreviation"
    abbreviationDisplay::UN{String} = nothing, "part-abbreviation-display"
    scoreinstrument::UN{Scoreinstrument} = nothing, "score-instrument"
    mididevice::UN{Mididevice} = nothing, "midi-device"
    midiinstrument::Midiinstrument, "midi-instrument"
    id::String, a"id"
end
################################################################
"""
    Partlist

# Arguments
```julia
- TODO partgroup
- scoreparts::Vector{Scorepart}
- aml::Node
```

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
```julia
- fifth::Int8
- mode::Union{Nothing,String}
- aml::Node

A type to hold key information for a measure in musicxml file.

The key element represents a key signature. Both traditional and non-traditional key signatures are supported. The optional number attribute refers to staff numbers. If absent, the key signature applies to all staves in the part.

fifth: number of flats or sharps in a traditional key signature. Negative numbers are used for flats and positive numbers for sharps, reflecting the key's placement within the circle of fifths

mode:  major, minor, dorian, phrygian, lydian, mixolydian, aeolian, ionian, locrian, none

[More info](https://usermanuals.musicxml.com/MusicXML/Content/CT-MusicXML-key.htm)
"""
@aml mutable struct Key "key"
    fifth::Int8, "fifths"
    mode::UN{String} = nothing, "mode"
end
################################################################
"""
    Clef

# Arguments
```julia
- sign::String
- line::Int16
- aml::Node
```

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
```julia
- diatonic::Int8
- chromatic::Int8
- octaveChange::Union{Nothing,Int8}
- double::Union{Nothing,Bool}
- aml::Node
```

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
    octaveChange::UN{Int8} = nothing, "octave-change"
    double::UN{Bool} = nothing, "double"
end
################################################################
"""
    Time

# Arguments
```julia
- beats::Int8 = 4, "beats"
- beattype::Int8 = 4, "beat-type"
```

Time signatures are represented by the beats element for the numerator and the beat-type element for the denominator.
"""
@aml mutable struct Time "time"
    beats::Int8 = 4, "beats"
    beattype::Int8 = 4, "beat-type"
end
################################################################
"""
    Attributes

# Arguments
```julia
- divisions::Int16
- key::Key
- time::Time
- staves::Union{Nothing, UInt16}
- instruments::Union{Nothing,UInt16}
- clef::Union{Nothing,Clef}
- transpose::Union{Nothing,Transpose}
- aml::Node
```

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
@aml mutable struct Attributes "attributes"
    divisions::Int16, "divisions"
    key::Key, "key"
    time::Time, "time"
    staves::UN{UInt16} = nothing, "staves"
    instruments::UN{UInt16} = nothing, "instruments"
    clef::UN{Clef} = nothing, "clef"
    transpose::UN{Transpose} = nothing, "transpose"
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
```julia
- step::String
- alter::Float16
- octave::Int8
- aml::Node
```

Holds musicxml pitch data. MusicXML pitch data is represented as a combination of the step of the diatonic scale, the chromatic alteration, and the octave.

Use step, alter, octave = pitch2xml(pitch) and  pitch = xml2pitch(step, alter, octave)
for conversions between midi pitch and musicxml pitch

"""
@aml mutable struct Pitch "pitch"
    step::String, "step"
    alter::UN{Float16} = nothing, "alter"
    octave::Int8, "octave"
end
################################################################
"""
    Rest

# Arguments
```julia
- rest::Bool
- aml::Node
```

The rest element indicates notated rests or silences. Rest elements are usually empty, but placement on the staff can be specified using display-step and display-octave elements. If the measure attribute is set to yes, this indicates this is a complete measure rest.

The display-step-octave group contains the sequence of elements used by both the rest and unpitched elements. This group is used to place rests and unpitched elements on the staff without implying that these elements have pitch. Positioning follows the current clef. If percussion clef is used, the display-step and display-octave elements are interpreted as if in treble clef, with a G in octave 4 on line 2. If not present, the note is placed on the middle line of the staff, generally used for a one-line staff.

"""
@aml mutable struct Rest sc"rest"
    measure::UN{YN} = nothing, a"measure"
    dispStep::UN{String} = nothing, "display-step"
    dispOctave::UN{Int8} = nothing, "display-octave"
end
################################################################
"""
    Unpitched

# Arguments
```julia
- unpitched::Bool
- aml::Node
```

The unpitched type represents musical elements that are notated on the staff but lack definite pitch, such as unpitched percussion and speaking voice.
"""
@aml mutable struct Unpitched sc"unpitched"
    measure::UN{YN} = nothing, a"measure"
    dispStep::UN{String} = nothing, "display-step"
    dispOctave::UN{Int8} = nothing, "display-octave"
end
################################################################
"""
    NoteX

# Arguments
```julia
- pitch::Pitch
- rest::Rest
- unpitched::Unpitched
- duration::UInt
- TODO voice
- type::String
- accidental::String
- TODO tie::Union{Nothing,Tie} # start, stop, nothing TODO
- TODO lyric
- aml::Node
```

Notes are the most common type of MusicXML data. The MusicXML format keeps the MuseData distinction between elements used for sound information and elements used for notation information (e.g., tie is used for sound, tied for notation). Thus grace notes do not have a duration element. Cue notes have a duration element, as do forward elements, but no tie elements. Having these two types of information available can make interchange considerably easier, as some programs handle one type of information much more readily than the other.

pitch: See [`Pitch`](@ref) doc

duration : See [`MIDI.Note`] (@ref) doc

type: Type indicates the graphic note type, Valid values (from shortest to longest) are 1024th, 512th, 256th, 128th, 64th, 32nd, 16th, eighth, quarter, half, whole, breve, long, and maxima. The size attribute indicates full, cue, or large size, with full the default for regular notes and cue the default for cue and grace notes.

accidental: The accidental type represents actual notated accidentals. Editorial and cautionary indications are indicated by attributes. Values for these attributes are "no" if not present. Specific graphic display such as parentheses, brackets, and size are controlled by the level-display attribute group. Empty accidental objects are not allowed. If no accidental is desired, it should be omitted. sharp, flat, natural, double sharp, double flat, parenthesized accidental

tie:

[More info](https://usermanuals.musicxml.com/MusicXML/Content/CT-MusicXML-note.htm)
"""
@aml mutable struct NoteX "note"
    pitch::UN{Pitch} = nothing, "pitch"
    rest::UN{Rest} = nothing, "rest"
    unpitched::UN{Unpitched} = nothing, "unpitched"
    duration::UInt, "duration"
    # voice
    type::UN{String} = nothing, "type"
    accidental::UN{String} = nothing, "accidental"
    tie::UN{String} = nothing, "tie" # start, stop, nothing TODO
end
################################################################
"""
    Measure

# Arguments
```julia
- attributes::Union{Nothing,Attributes}
- notes::Vector{NoteX}
- aml::Node
```

A type to hold the data for a musicxml measure

attributes: See [`Attributes`](@ref) doc
notes: See [`NoteX`](@ref) doc

"""
@aml mutable struct Measure "measure"
    attributes::UN{Attributes} = nothing, "attributes"
    notes::Vector{NoteX}, "note"
end
################################################################
"""
    Part

# Arguments
```julia
- measures::Vector{Measure}
- id::String
- aml::Node
```

A type to hold the data for a part in musicxml file.

measures: See [`Measure`](@ref) doc

"""
@aml mutable struct Part "part"
    measures::Vector{Measure}, "measure"
    id::String, a"id"
end
################################################################
"""
    scorePartwise

# Arguments
```julia
- TODO identification
- TODO defaults
- partlist::Partlist
- parts::Vector{Part}
- aml::Node
```

A type to hold the data for a musicxml file.
"""
@aml mutable struct Scorepartwise "score-partwise"
    # TODO identification
    # TODO defaults
    partlist::Partlist, "part-list"
    parts::Vector{Part}, "part"
end

@aml mutable struct Doc xd""
    scorepartwise::Scorepartwise, "score-partwise"
end
################################################################
"""
    extractdata(doc)

Extracts musicxml data, builds all the types and stores them in proper format.

This function is not exported. Use readmusicxml and parsemusicxml instead.

# Examples
```julia
data = extractdata(doc)
```
"""
extractdata(doc::Document) = Doc(doc)
################################################################
"""
    readmusicxml(filepath)

Reads musicxml file and then extracts the data, builds all the types and stores them in proper format.


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

Parses musicxml from a string and then extracts the data, builds all the types and stores them in proper format.

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
