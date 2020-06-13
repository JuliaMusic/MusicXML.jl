export pitch2xml, xml2pitch

using Base.Meta, Base.Unicode
const PITCH_TO_NAME = Dict(
0=>"C", 1=>"C♯", 2=>"D", 3=>"D♯", 4=>"E", 5=>"F", 6=>"F♯", 7=>"G", 8=>"G♯", 9=>"A",
10 =>"A♯", 11=>"B")
const SHARPS = [1, 3, 6, 8, 10]
const NAME_TO_PITCH = Dict(
v => k for (v, k) in zip(values(PITCH_TO_NAME), keys(PITCH_TO_NAME)))

"""
    pitch2xml(pitch)

Return the musicxmls values of the given pitch (MIDI)

pitch::UInt8 : starting from C-1 = 0, adding one per semitone.


![Step Alter Octave on Staff](docs/pitchesonstaff.png)
![Pitch on Guitar](docs/pitchesonguitar.png)
![Pitch on Full Keyboard](docs/fullpiano.gif)

Modified from MIDI.jl

# Examples:
```julia
pitch = 0 # for C-1
step, alter, octave = pitch2xml()
```
"""
function pitch2xml(pitch::UInt8)
    intpitch = Int(pitch)
    # TODO: microtonals
    rem = mod(intpitch, 12)
    notename = PITCH_TO_NAME[rem]

    if rem in SHARPS
        step = notename[1]
        alter = 1 # using sharps by default (this is only for sound)
    else
        step = notename
        alter = 0
    end

    octave = (intpitch÷12)-1
    return step, alter, octave
end
################################################################
"""
    xml2pitch(step, alter, octave) -> Int
Return the pitch value of the given note

See [`Pitch`](@ref)

Modified from MIDI.jl

# Examples:
```julia
pitch = xml2pitch(step, alter, octave)
```
"""
function xml2pitch(step, alter, octave)

    pitch = NAME_TO_PITCH[step]

    return pitch + alter + 12(octave+1) # lowest possible octave is -1 but pitch starts from 0
end
