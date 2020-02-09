using MusicXML
using Test

cd(@__DIR__)

@testset "MusicXML.jl" begin

    @testset "example" begin
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
    end

end
