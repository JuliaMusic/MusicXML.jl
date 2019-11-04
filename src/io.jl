# I/O functions
export readmusicxml, parsemusicxml

"""
    extractdata(doc)

Extracts musicxml data, builds all the types and stores them in proper format.

This function is not exported. Use readmusicxml and parsemusicxml instead.

# Examples
```julia
data = extractdata(doc)
```
"""
extractdata(doc::Document) = Doc(doc)
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
