using MusicXML
using Documenter

makedocs(;
    modules=[MusicXML],
    authors="Amin Yahyaabadi",
    repo="https://github.com/aminya/MusicXML.jl/blob/{commit}{path}#L{line}",
    sitename="MusicXML.jl",
    format=Documenter.HTML(;
        canonical="https://aminya.github.io/MusicXML.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/aminya/MusicXML.jl",
)
