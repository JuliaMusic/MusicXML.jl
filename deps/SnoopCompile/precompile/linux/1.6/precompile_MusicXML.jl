function _precompile_()
    ccall(:jl_generating_output, Cint, ()) == 1 || return nothing
    Base.precompile(Tuple{Core.kwftype(typeof(MusicXML.Type)),NamedTuple{(:channel, :program, :volume, :pan, :id), Tuple{Int64, Int64, Int64, Int64, String}},Type{MidiInstrument}})
    Base.precompile(Tuple{Core.kwftype(typeof(MusicXML.Type)),NamedTuple{(:name, :midiinstrument, :id), Tuple{String, MidiInstrument, String}},Type{ScorePart}})
    Base.precompile(Tuple{Core.kwftype(typeof(MusicXML.Type)),NamedTuple{(:partlist, :parts), Tuple{PartList, Vector{Part}}},Type{ScorePartwise}})
    Base.precompile(Tuple{Core.kwftype(typeof(MusicXML.Type)),NamedTuple{(:time, :divisions, :clef, :staves, :key), Tuple{Time, Int64, Vector{Clef}, Int64, Key}},Type{Attributes}})
    Base.precompile(Tuple{typeof(Base.vect),ScorePart,Vararg{ScorePart, N} where N})
    Base.precompile(Tuple{typeof(println),Base.PipeEndpoint,Pitch})
    Base.precompile(Tuple{typeof(println),Pitch})
    Base.precompile(Tuple{typeof(readmusicxml),String})
    Base.precompile(Tuple{typeof(writemusicxml),String,Vararg{Any, N} where N})
end
