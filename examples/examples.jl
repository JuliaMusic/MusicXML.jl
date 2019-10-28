using MusicXML

# Reads musicxml file and then extracts the data, builds all the types and stores them in proper format.
doc = readmusicxml(joinpath("examples", "musescore.musicxml"))

# Example1:
# Prints Each instrument name and then the pitches

# Extracting each instrument information
scprts = doc.scorepartwise.partlist.scoreparts

# Extracting parts
prts = doc.scorepartwise.parts

# Extracting each part
for prt in prts

    ind = findfirst(x -> prt.ID == x.ID, scprts) # returns the index of scorepart that matches the ID of part

    # printing the instrument name
    println(scprts[ind].name)

    # Extracting each measure of the part
    for msr in prt.measures

        # Extracting notes of each measure
        for nt in msr.notes

            if !isnothing(nt.pitch)
            # print pitch of the note
                println(nt.pitch)
            end

        end


    end
end
