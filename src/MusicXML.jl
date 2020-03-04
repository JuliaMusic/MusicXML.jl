module MusicXML

# Alias
export MX
const MX = MusicXML

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
