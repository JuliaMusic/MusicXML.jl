# Types

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

```@index
Modules = [MusicXML]
Pages   = ["types.md"]
```

```@autodocs
Modules = [MusicXML]
Pages   = ["types.jl"]
```
