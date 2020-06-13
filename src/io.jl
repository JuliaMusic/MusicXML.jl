# I/O functions
export readmusicxml, parsemusicxml, writemusicxml, printmusicxml, pprint, fwritemusicxml, readmusicxml_partial, parsemusicxml_partial

"""
    extractdata(doc)

Extracts musicxml data, builds all the types and stores them in proper format.

This function is not exported. Use readmusicxml and parsemusicxml instead.

# Examples
```julia
data = extractdata(doc)
```
"""
extractdata(doc::Document) = ScorePartwise(doc)
################################################################
"""
    readmusicxml(filepath)

Reads musicxml file and then extracts the data, builds all the types and stores them in proper format.


# Examples
```julia
data = readmusicxml(joinpath("examples", "musescore.musicxml"))
```
"""
function readmusicxml(filepath::String)
    doc = readxml(filepath) # read an XML document from a file
    data = extractdata(doc)
    return data
end
################################################################

"""
Similar to [`readmusicxml`](@ref) but without converting it to a Julia type. Use the appropriate type to convert it

# Examples
```julia
xml_note = readmusicxml_partial(path_to_file)
Note(xml_note)
```
"""
function readmusicxml_partial(filepath::String)
    doc = readxml(filepath) # read an XML document from a file
    return doc
end
################################################################
"""
    parsemusicxml(s)

Parses musicxml from a string and then extracts the data, builds all the types and stores them in proper format.

# Examples
```julia
data = parsemusicxml(s)
```
"""
function parsemusicxml(s::String)
    doc = parsexml(s) # Parse an XML string
    data = extractdata(doc)
    return data
end

################################################################
"""
Similar to [`parsemusicxml`](@ref) but without converting it to a Julia type. Use the appropriate type to convert it

# Examples
```julia
xml_note = parsemusicxml_partial(\"\"\"
<note>
  <grace/>
  <pitch>
    <step>G</step>
    <octave>4</octave>
  </pitch>
  <voice>1</voice>
  <type>16th</type>
  <stem>up</stem>
  <beam number="1">end</beam>
  <beam number="2">end</beam>
</note>
\"\"\")

Note(xml_note)
```
"""
function parsemusicxml_partial(s::String)
    doc = parsexml(s) # Parse an XML string
    return doc
end

################################################################
"""
    writemusicxml(filename::AbstractString, x)

Writes musicxml score into a file.

# Examples
```julia
writemusicxml("myscore.musicxml", score)
```
"""
function writemusicxml end

################################################################
"""
    printmusicxml(x)
    printmusicxml(io, x)

Print musicxml score

# Examples
```julia
printmusicxml(score)
```
"""
function printmusicxml end

writemusicxml(args...) = pprint(args...)
printmusicxml(args...) = pprint(args...)


################################################################
"""
 fwritemusicxml(filename::AbstractString, x)

Fast write
"""
fwritemusicxml(io_filename, score) = Base.write(io_filename, score.aml)
