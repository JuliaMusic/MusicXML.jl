# MusicXML

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaMusic.github.io/MusicXML.jl/dev)

![Build Status (Github Actions)](https://github.com/aminya/MusicXML.jl/workflows/CI/badge.svg)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)


Powerful MusicXML reading and writing package for Julia.

# Installation and Usage
```julia
using Pkg
Pkg.add("MusicXML")
```
```julia
using MusicXML
```

# Documentation

Please see [![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaMusic.github.io/MusicXML.jl/dev). This readme is just a taste of the actual documentation.

# Creating Example
```julia
using MusicXML
@importMX # imports all the MusicXML types since we know there is no conflict

## Part List
### Piano
midiinstrument_piano = MidiInstrument(channel= 1, program =1, volume = 100, pan =0, id = "P1-I1")
scorepart_piano = ScorePart(name = "Piano", midiinstrument = midiinstrument_piano, id = "P1")

### Acoustic Guitar
midiinstrument_guitar = MidiInstrument(channel= 1, program =26, volume = 100, pan =0, id = "P2-I1")
scorepart_guitar = ScorePart(name = "Acoustic Guitar", midiinstrument = midiinstrument_guitar, id = "P2")

###
partlist = PartList(scoreparts = [scorepart_piano, scorepart_guitar])

## Part
### Piano

attributes1_piano = Attributes(
   time = Time(beats = 4, beattype = 4), # 4/4
   divisions = 4, # we want to use 16th notes at minimum
   clef = [Clef(number = 1, sign = "G", line = 2), Clef(number = 2, sign = "F", line = 4)], # Piano clefs
   staves = 2, # Piano staves
   key = Key(fifths = 0, mode = "major"), # no accidentals, major key
)

measure1_notes_piano = [
Note(pitch = Pitch(step = "C", alter = 0, octave = 4), duration =  4),
Note(pitch = Pitch(step = "D", alter = 0, octave = 4), duration =  4),
Note(pitch = Pitch(step = "E", alter = 0, octave = 4), duration =  4),
Note(pitch = Pitch(step = "F", alter = +1, octave = 4), duration =  4),
]

measure2_notes_piano = [
Note(pitch = Pitch(step = "G", alter = 0, octave = 5), duration =  1),
Note(pitch = Pitch(step = "G", alter = +1, octave = 5), duration =  1),
Note(pitch = Pitch(step = "B", alter = 0, octave = 5), duration =  1),
Note(pitch = Pitch(step = "A", alter = +1, octave = 5), duration =  1),
Note(rest = Rest(), duration =  4), # Rest
Note(pitch = Pitch(step = "A", alter = 0, octave = 5), duration =  4),
Note(pitch = Pitch(step = "B", alter = 0, octave = 5), duration =  4),
]

measures_piano = [
Measure(attributes = attributes1_piano, notes = measure1_notes_piano) # measure 1 has attributes
Measure(notes = measure2_notes_piano)
]


part_piano = Part(measures = measures_piano, id = "P1")


### Guitar

attributes1_guitar = Attributes(
   time = Time(beats = 4, beattype = 4), # 4/4
   divisions = 4, # we want to use 16th notes at minimum
   clef = [Clef(number = 1, sign = "G", line = 2), Clef(number = 2, sign = "TAB", line = 6)], # Guitar Clefs
   staves = 2, # Guitar staves
   key = Key(fifths = 0, mode = "major"), # no accidentals, major key
)

measure1_notes_guitar = [
# G Major chord for a bar
Note(pitch = Pitch(step = "G", alter = 0, octave = 2), duration =  16),
Note(pitch = Pitch(step = "B", alter = 0, octave = 2), duration =  16, chord = Chord()),
Note(pitch = Pitch(step = "D", alter = 0, octave = 3), duration =  16, chord = Chord()),
Note(pitch = Pitch(step = "G", alter = 0, octave = 3), duration =  16, chord = Chord()),
Note(pitch = Pitch(step = "D", alter = 0, octave = 4), duration =  16, chord = Chord()),
Note(pitch = Pitch(step = "G", alter = 0, octave = 4), duration =  16, chord = Chord()),
]

measure2_notes_guitar = [
# G Major chord for half a bar
Note(pitch = Pitch(step = "G", alter = 0, octave = 2), duration =  8),
Note(pitch = Pitch(step = "B", alter = 0, octave = 2), duration =  8, chord = Chord()),
Note(pitch = Pitch(step = "D", alter = 0, octave = 3), duration =  8, chord = Chord()),
Note(pitch = Pitch(step = "G", alter = 0, octave = 3), duration =  8, chord = Chord()),
Note(pitch = Pitch(step = "D", alter = 0, octave = 4), duration =  8, chord = Chord()),
Note(pitch = Pitch(step = "G", alter = 0, octave = 4), duration =  8, chord = Chord()),

# G Major chord for half a bar
Note(pitch = Pitch(step = "G", alter = 0, octave = 2), duration =  8),
Note(pitch = Pitch(step = "B", alter = 0, octave = 2), duration =  8, chord = Chord()),
Note(pitch = Pitch(step = "D", alter = 0, octave = 3), duration =  8, chord = Chord()),
Note(pitch = Pitch(step = "G", alter = 0, octave = 3), duration =  8, chord = Chord()),
Note(pitch = Pitch(step = "D", alter = 0, octave = 4), duration =  8, chord = Chord()),
Note(pitch = Pitch(step = "G", alter = 0, octave = 4), duration =  8, chord = Chord()),
]

measures_guitar = [
Measure(attributes = attributes1_guitar, notes = measure1_notes_guitar) # measure 1 has attributes
Measure(notes = measure2_notes_guitar)
]


part_guitar = Part(measures = measures_guitar, id = "P2")

##
score = ScorePartwise(
partlist = partlist,
parts =  [part_piano, part_guitar],
)

writemusicxml("myscore.musicxml", score)
```

# Parsing Example
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
readmusicxml, parsemusicxml, writemusicxml, printmusicxml, pprint, fwritemusicxml, readmusicxml_partial, parsemusicxml_partial
```

## Typess:

Since MusicXML's types are not exported from the package to avoid conflicts with the similarly named types from other libraries (such as `Dates.Time`, `MIDI.Note`). There are 3 different solutions:
1) `import` the types yourself if you are sure that there is no conflict. Use `@importMX` to `import` all the types.
2) or use `MX.` before the type names (which `MX` is an alias for `MusicXML`)
3) or use `@MX` macro, which adds `MX.` automatically to the type names. See `@MX` docstring for examples.

```
ScorePartwise
	partlist (PartList)
		scoreparts (Vector{ScorePart})
			name
			id
			scoreinstrument (ScoreInstrument)
				name
				id
			mididevice (MidiDevice)
				port
				id
			midiinstrument (MidiInstrument)
				channel
				program
				volume
				pan
				id
	part (Part)
		id
		measures (Vector{Measure})
			attributes (Attributes)
				divisions
				key (Key)
					fifth
					mode
				time (Time)
					beats
					beattype
				staves
				instruments
				clefs (Vector{Clef})
					sign
					line
				transpose (Transpose)
					diatonic
					chromatic
					octaveChange
					double
			notes (Vector{Note})
				grace (Grace)
				pitch (Pitch)
					step
					alter
					octave
				rest (Rest)
				unpitched (Unpitched)
				duration
				type
				accidental
				chord (Chord)
```

For fieldnames, if it is a Vector it has `s` at the end of the word.

For types, names are capitalized for each word (Camel convention):
```
ScorePartwise, Part, Measure, Note, Chord, Unpitched, Rest, Pitch, Grace, Attributes, Time, Transpose, Clef, Key, PartList, ScorePart, MidiInstrument, MidiDevice, ScoreInstrument
```

## Utilities
```julia
pitch2xml, xml2pitch
```
