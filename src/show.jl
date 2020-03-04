MusicXMLTypes = [:ScorePartwise, :Part, :Measure, :Note, :Unpitched, :Rest, :Pitch, :Attributes, :Time, :Transpose, :Clef, :Key, :PartList, :ScorePart, :MidiInstrument, :MidiDevice, :ScoreInstrument]

import TreeViews: hastreeview, numberofnodes, treelabel, treenode
import Base: inferencebarrier, show_circular
for T in MusicXMLTypes
    @eval begin
        function Base.show(io::IO, x::$T)
            # code from Base
            t = typeof(x)
            show(io, inferencebarrier(t))
            print(io, '(')
            nf = nfields(x)
            nb = sizeof(x)
            if nf != 0 || nb == 0
                if !show_circular(io, x)
                    recur_io = IOContext(io, Pair{Symbol,Any}(:SHOWN_SET, x),
                                         Pair{Symbol,Any}(:typeinfo, Any))
                    for i in 1:nf-1 # skip last
                        f = fieldname(t, i)
                        if !isdefined(x, f)
                            print(io, undef_ref_str)
                        else
                            show(recur_io, getfield(x, i))
                        end
                        if i < nf
                            print(io, ", ")
                        end
                    end
                    print(io, "aml")
                end
            else
                print(io, "0x")
                r = Ref(x)
                GC.@preserve r begin
                    p = unsafe_convert(Ptr{Cvoid}, r)
                    for i in (nb - 1):-1:0
                        print(io, string(unsafe_load(convert(Ptr{UInt8}, p + i)), base = 16, pad = 2))
                    end
                end
            end
            print(io,')')
        end
        # Juno
        Base.show(io::IO, ::MIME"application/prs.juno.inline", x::$T) = x
        # hastreeview(::$T) = true
        numberofnodes(::$T) = fieldcount($T)-1
    end
end
