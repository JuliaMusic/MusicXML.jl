using MusicXML
cd(@__DIR__)
# Reads musicxml file and then extracts the data, builds all the types and stores them in proper format.
scorepartwise = readmusicxml( "musescore.musicxml")

# Example 1:
# Prints Each instrument name and then the pitches

# Extracting each instrument information
scoreparts = scorepartwise.partlist.scoreparts

# Extracting parts
parts = scorepartwise.parts

# Extracting each part
for part in parts

    ind = findfirst(x -> part.id == x.id, scoreparts) # returns the index of scorepart that matches the id of part

    # printing the instrument name
    println(scoreparts[ind].name)

    # Extracting each measure of the part
    iMsr=1
    for measure in part.measures
        # Extracting notes of each measure
        for note in measure.notes
            if !isnothing(note.pitch)

                println("Measure no. $iMsr")    # print measure number
                println(note.pitch)     # print pitch of the note
                println(note.duration)  # print duration of the note
            elseif !isnothing(note.unpitched)
                println("Measure no. $iMsr")    # print measure number
                println(note.unpitched) # print unpitched of the note
                println(note.duration)  # print duration of the note
            end

        end

        iMsr+=1
    end
end
