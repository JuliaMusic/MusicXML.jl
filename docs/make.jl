using MusicXML
using Documenter

# using Pkg
# pkg"activate .."
# push!(LOAD_PATH,"../src/")

makedocs(;
    modules=[MusicXML],
    authors="Amin Yahyaabadi",
    repo="https://github.com/JuliaMusic/MusicXML.jl/blob/{commit}{path}#L{line}",
    sitename="MusicXML.jl",
    format=Documenter.HTML(;
        prettyurls = prettyurls = get(ENV, "CI", nothing) == "true",
        canonical="https://JuliaMusic.github.io/MusicXML.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Parsing Example" => "parsing.md",
        "Creating Example" => "creating.md",
        "Types" => "types.md",
        "IO" => "io.md",
        "Utilities" => "utilities.md",
    ],
)

deploydocs(;
    repo="github.com/JuliaMusic/MusicXML.jl",
)
