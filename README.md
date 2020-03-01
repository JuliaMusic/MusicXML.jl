# MusicXML

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaMusic.github.io/MusicXML.jl/dev)
![Build Status (Github Actions)](https://github.com/aminya/MusicXML.jl/workflows/CI/badge.svg)

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

Powerful MusicXML reading and writing package for Julia.

# Installation
```julia
] add https://github.com/JuliaMusic/MusicXML.jl
```


# Usage Example
```julia
using MusicXML

# Reads musicxml file and then extracts the data, builds all the types and stores them in proper format.
scorepartwise = readmusicxml( "musescore.musicxml")

# Example 1:
# Prints Each instrument name and then the pitches

# Extracting each instrument information
scprts = scorepartwise.partlist.scoreparts

# Extracting parts
prts = scorepartwise.parts

# Extracting each part
for prt in prts

    ind = findfirst(x -> prt.id == x.id, scprts) # returns the index of scorepart that matches the id of part

    # printing the instrument name
    println(scprts[ind].name)

    # Extracting each measure of the part
    iMsr=1
    for msr in prt.measures
        # Extracting notes of each measure
        for nt in msr.notes
            if !isnothing(nt.pitch)

                println("Measure no. $iMsr")    # print measure number
                println(nt.pitch)     # print pitch of the note
                println(nt.duration)  # print duration of the note
            elseif !isnothing(nt.unpitched)
                println("Measure no. $iMsr")    # print measure number
                println(nt.unpitched) # print unpitched of the note
                println(nt.duration)  # print duration of the note
            end

        end

        iMsr+=1
    end
end
```


# Types and Functions

You can use among these exported types and functions:

## I/O functions
```julia
readmusicxml, parsemusicxml
```

## Types:

```
scorepartwise
	partlist
		scoreparts
			name
			id
			ScoreInstrument
				name
				id
			MidiDevice
				port
				id
			MidiInstrument
				channel
				program
				volume
				pan
				id
	parts
		id
		measures
			attributes
				divisions
				key
					fifth
					mode
				time
					beats
					beattype
				staves
				instruments
				clef
					sign
					line
				transpose
					diatonic
					chromatic
					octaveChange
					double
			notes
				pitch
					step
					alter
					octave
				rest
				unpitched
				duration
				type
				accidental
```

For naming, If the fieldname is a Vector it has `s` at the end of the word.

For naming, types are first letter captalized of the field names:
```
ScorePartwise, Part, Measure, NoteX, Unpitched, Rest, Pitch, Attributes, Time, Transpose, Clef, Key, PartList, ScorePart, MidiInstrument, MidiDevice, ScoreInstrument
```


## Utilities
```julia
pitch2xml, xml2pitch
```
