module MusicXML

# Alias
export MX
const MX = MusicXML

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

# precompile
include("../deps/SnoopCompile/precompile/precompile_MusicXML.jl")
_precompile_()

end
