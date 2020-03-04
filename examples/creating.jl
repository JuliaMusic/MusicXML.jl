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
Note(pitch = Pitch(step = "G", alter = 0, octave = 2), duration =  16, chord = Chord()),
Note(pitch = Pitch(step = "B", alter = 0, octave = 2), duration =  16, chord = Chord()),
Note(pitch = Pitch(step = "D", alter = 0, octave = 3), duration =  16, chord = Chord()),
Note(pitch = Pitch(step = "G", alter = 0, octave = 3), duration =  16, chord = Chord()),
Note(pitch = Pitch(step = "D", alter = 0, octave = 4), duration =  16, chord = Chord()),
Note(pitch = Pitch(step = "G", alter = 0, octave = 4), duration =  16, chord = Chord()),
]

measure2_notes_guitar = [
# G Major chord for half a bar
Note(pitch = Pitch(step = "G", alter = 0, octave = 2), duration =  8, chord = Chord()),
Note(pitch = Pitch(step = "B", alter = 0, octave = 2), duration =  8, chord = Chord()),
Note(pitch = Pitch(step = "D", alter = 0, octave = 3), duration =  8, chord = Chord()),
Note(pitch = Pitch(step = "G", alter = 0, octave = 3), duration =  8, chord = Chord()),
Note(pitch = Pitch(step = "D", alter = 0, octave = 4), duration =  8, chord = Chord()),
Note(pitch = Pitch(step = "G", alter = 0, octave = 4), duration =  8, chord = Chord()),

# G Major chord for half a bar
Note(pitch = Pitch(step = "G", alter = 0, octave = 2), duration =  8, chord = Chord()),
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
