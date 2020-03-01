# Types

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
				clef (Clef)
					sign
					line
				transpose (Transpose)
					diatonic
					chromatic
					octaveChange
					double
			notes (Vector{NoteX})
				pitch (Pitch)
					step
					alter
					octave
				rest (Rest)
				unpitched (Unpitched)
				duration
				type
				accidental
```

For fieldnames, if it is a Vector it has `s` at the end of the word.

For types, names are capitalized for each word (Camel convention):
```
ScorePartwise, Part, Measure, NoteX, Unpitched, Rest, Pitch, Attributes, Time, Transpose, Clef, Key, PartList, ScorePart, MidiInstrument, MidiDevice, ScoreInstrument
```


```@index
Modules = [MusicXML]
Pages   = ["types.md"]
```

```@autodocs
Modules = [MusicXML]
```
