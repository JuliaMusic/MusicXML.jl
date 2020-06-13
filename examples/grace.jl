# https://github.com/JuliaMusic/MusicXML.jl/issues/46
using MusicXML

@importMX
xml_note = parsemusicxml_partial("""
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
""")

Note(xml_note)
