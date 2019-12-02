function _precompile_()
    ccall(:jl_generating_output, Cint, ()) == 1 || return nothing
    precompile(Tuple{typeof(MusicXML.midi16384), Nothing})
    precompile(Tuple{typeof(MusicXML.modeCheck), String})
    precompile(Tuple{typeof(MusicXML.modeCheck), Nothing})
    precompile(Tuple{typeof(MusicXML.rot180), Nothing})
    precompile(Tuple{typeof(MusicXML.percent), Nothing})
    precompile(Tuple{typeof(MusicXML.midi16), Nothing})
    precompile(Tuple{typeof(MusicXML.readmusicxml), String})
end
