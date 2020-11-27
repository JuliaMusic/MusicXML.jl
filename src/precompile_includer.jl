should_precompile = true


# Don't edit the following! Instead change the script for `snoop_bot`.
ismultios = true
ismultiversion = true
# precompile_enclosure
@static if !should_precompile
    # nothing
elseif !ismultios && !ismultiversion
    @static if (isfile("../deps/SnoopCompile/precompile/precompile_MusicXML.jl"))
        include("../deps/SnoopCompile/precompile/precompile_MusicXML.jl")
        _precompile_()
    end
else
    @static if Sys.islinux()
        @static if v"1.2.0-DEV" <= VERSION <= v"1.2.9"
            @static if (isfile("../deps/SnoopCompile/precompile/linux/1.2/precompile_MusicXML.jl"))
                include("../deps/SnoopCompile/precompile/linux/1.2/precompile_MusicXML.jl")
                _precompile_()
            end
        elseif v"1.3.0-DEV" <= VERSION <= v"1.3.9"
            @static if (isfile("../deps/SnoopCompile/precompile/linux/1.3/precompile_MusicXML.jl"))
                include("../deps/SnoopCompile/precompile/linux/1.3/precompile_MusicXML.jl")
                _precompile_()
            end
        elseif v"1.4.0-DEV" <= VERSION <= v"1.4.9"
            @static if (isfile("../deps/SnoopCompile/precompile/linux/1.4/precompile_MusicXML.jl"))
                include("../deps/SnoopCompile/precompile/linux/1.4/precompile_MusicXML.jl")
                _precompile_()
            end
        elseif v"1.5.0-DEV" <= VERSION <= v"1.5.9"
            @static if (isfile("../deps/SnoopCompile/precompile/linux/1.5/precompile_MusicXML.jl"))
                include("../deps/SnoopCompile/precompile/linux/1.5/precompile_MusicXML.jl")
                _precompile_()
            end
        elseif v"1.6.0-DEV" <= VERSION <= v"1.6.9"
            @static if (isfile("../deps/SnoopCompile/precompile/linux/1.6/precompile_MusicXML.jl"))
                include("../deps/SnoopCompile/precompile/linux/1.6/precompile_MusicXML.jl")
                _precompile_()
            end
        else
        end

    elseif Sys.iswindows()
        @static if v"1.2.0-DEV" <= VERSION <= v"1.2.9"
            @static if (isfile("../deps/SnoopCompile/precompile/windows/1.2/precompile_MusicXML.jl"))
                include("../deps/SnoopCompile/precompile/windows/1.2/precompile_MusicXML.jl")
                _precompile_()
            end
        elseif v"1.3.0-DEV" <= VERSION <= v"1.3.9"
            @static if (isfile("../deps/SnoopCompile/precompile/windows/1.3/precompile_MusicXML.jl"))
                include("../deps/SnoopCompile/precompile/windows/1.3/precompile_MusicXML.jl")
                _precompile_()
            end
        elseif v"1.4.0-DEV" <= VERSION <= v"1.4.9"
            @static if (isfile("../deps/SnoopCompile/precompile/windows/1.4/precompile_MusicXML.jl"))
                include("../deps/SnoopCompile/precompile/windows/1.4/precompile_MusicXML.jl")
                _precompile_()
            end
        elseif v"1.5.0-DEV" <= VERSION <= v"1.5.9"
            @static if (isfile("../deps/SnoopCompile/precompile/windows/1.5/precompile_MusicXML.jl"))
                include("../deps/SnoopCompile/precompile/windows/1.5/precompile_MusicXML.jl")
                _precompile_()
            end
        elseif v"1.6.0-DEV" <= VERSION <= v"1.6.9"
            @static if (isfile("../deps/SnoopCompile/precompile/windows/1.6/precompile_MusicXML.jl"))
                include("../deps/SnoopCompile/precompile/windows/1.6/precompile_MusicXML.jl")
                _precompile_()
            end
        else
        end

    elseif Sys.isapple()
        @static if v"1.2.0-DEV" <= VERSION <= v"1.2.9"
            @static if (isfile("../deps/SnoopCompile/precompile/apple/1.2/precompile_MusicXML.jl"))
                include("../deps/SnoopCompile/precompile/apple/1.2/precompile_MusicXML.jl")
                _precompile_()
            end
        elseif v"1.3.0-DEV" <= VERSION <= v"1.3.9"
            @static if (isfile("../deps/SnoopCompile/precompile/apple/1.3/precompile_MusicXML.jl"))
                include("../deps/SnoopCompile/precompile/apple/1.3/precompile_MusicXML.jl")
                _precompile_()
            end
        elseif v"1.4.0-DEV" <= VERSION <= v"1.4.9"
            @static if (isfile("../deps/SnoopCompile/precompile/apple/1.4/precompile_MusicXML.jl"))
                include("../deps/SnoopCompile/precompile/apple/1.4/precompile_MusicXML.jl")
                _precompile_()
            end
        elseif v"1.5.0-DEV" <= VERSION <= v"1.5.9"
            @static if (isfile("../deps/SnoopCompile/precompile/apple/1.5/precompile_MusicXML.jl"))
                include("../deps/SnoopCompile/precompile/apple/1.5/precompile_MusicXML.jl")
                _precompile_()
            end
        elseif v"1.6.0-DEV" <= VERSION <= v"1.6.9"
            @static if (isfile("../deps/SnoopCompile/precompile/apple/1.6/precompile_MusicXML.jl"))
                include("../deps/SnoopCompile/precompile/apple/1.6/precompile_MusicXML.jl")
                _precompile_()
            end
        else
        end

    else
    end

end # precompile_enclosure
