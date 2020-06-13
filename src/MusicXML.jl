module MusicXML

# Alias
export MX
const MX = MusicXML

# Type Importer Macro
export @importMX
"""
    @importMX

Imports all the MusicXML types in case you are sure no conflicts happens.

# Just put it in the code:
```julia
@importMX # gets translated to: import MusicXML: ScorePartwise, Part, Measure, Note, Chord, Unpitched, Rest, Pitch, Grace, Attributes, Time, Transpose, Clef, Key, PartList, ScorePart, MidiInstrument, MidiDevice, ScoreInstrument
```
"""
macro importMX()
    out = quote
        import MusicXML: ScorePartwise, Part, Measure, Note, Chord, Unpitched, Rest, Pitch, Grace, Attributes, Time, Transpose, Clef, Key, PartList, ScorePart, MidiInstrument, MidiDevice, ScoreInstrument
    end
    return out
end

# Type Helper Macro
export @MX
"""
    @MX

A macro that adds `MX.` to the name of the MusicXML types.

Since MusicXML's types are not exported from the package to avoid conflicts with the similarly named types from other libraries (such as `Dates.Time`, `MIDI.Note`), `@MX` is given that facilitates using MusicXML types.

`@MX` assumes that all the types with these kinds of names inside in front of a macro, between `()`, or between `begin end` are MusicXML types unless explicitly written (e.g. `MIDI.Note`).

!!! warn
    It will replace the name of the types if they are used inside strings.

# Examples
```julia
@MX begin
    Note(pitch = Pitch(step = "C", alter = 0, octave = 4), duration =  4))
    # all the code ...
end
```
is translated to:
```julia
    MX.Note(pitch = Pitch(step = "C", alter = 0, octave = 4), duration =  4))
```

Type is untouched if it is called explicitly from another library:
```julia
@MX Dates.Time(12,53,40)
```
remains as:
```julia
Dates.Time(12,53,40)
```
"""
macro MX(expr)
    expr_string = string(expr)
    expr_string = reduce(replace,
        (
        r"(?<!\.)\bScorePartwise\b" => "MX.ScorePartwise",
        r"(?<!\.)\bPart\b" => "MX.Part",
        r"(?<!\.)\bMeasure\b" => "MX.Measure",
        r"(?<!\.)\bNote\b" => "MX.Note",
        r"(?<!\.)\bChord\b" => "MX.Chord",
        r"(?<!\.)\bUnpitched\b" => "MX.Unpitched",
        r"(?<!\.)\bRest\b" => "MX.Rest",
        r"(?<!\.)\bPitch\b" => "MX.Pitch",
        r"(?<!\.)\bAttributes\b" => "MX.Attributes",
        r"(?<!\.)\bTime\b" => "MX.Time",
        r"(?<!\.)\bTranspose\b" => "MX.Transpose",
        r"(?<!\.)\bClef\b" => "MX.Clef",
        r"(?<!\.)\bKey\b" => "MX.Key",
        r"(?<!\.)\bPartList\b" => "MX.PartList",
        r"(?<!\.)\bScorePart\b" => "MX.ScorePart",
        r"(?<!\.)\bMidiInstrument\b" => "MX.MidiInstrument",
        r"(?<!\.)\bMidiDevice\b" => "MX.MidiDevice",
        r"(?<!\.)\bScoreInstrument\b" => "MX.ScoreInstrument",
        ),
        init = expr_string)
    return esc(Meta.parse(expr_string))
end

using AcuteML


# I/O functions
include("io.jl")
# Types:
include("types.jl")

# Utilities
include("utilities.jl")

################################################################
# include("show.jl")


end
