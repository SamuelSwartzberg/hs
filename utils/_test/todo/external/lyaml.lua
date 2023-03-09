local tbl_to_be_dumped = ovtable.new()


tbl_to_be_dumped["s"] = { value = "foo"}
tbl_to_be_dumped["short"] = { value = "awawai", comment = "I has comment"}
tbl_to_be_dumped["longlonglong"] = { value = "b8"}
tbl_to_be_dumped["kindashort"] = { value = "b8", comment = "this is a longer comment"}
tbl_to_be_dumped["shrt"] = { value = "awainomono"}
tbl_to_be_dumped["nested"] = ovtable.new()
tbl_to_be_dumped["nested"]["nested"] = ovtable.new()
tbl_to_be_dumped["nested"]["nested"]["foo"] = { value = "bar"}
tbl_to_be_dumped["nested"]["bar"] = { value = "baz", comment = "I'm running out of nonsense words"}
tbl_to_be_dumped["longagain"] = { value = "meeepmoop"}



assertMessage(
  yamlDumpAligned(tbl_to_be_dumped),
[[s:            foo
short:        awawai     # I has comment
longlonglong: b8
kindashort:   b8         # this is a longer comment
shrt:         awainomono
nested:       
  nested:     
    foo:      bar
  bar:        baz        # I'm running out of nonsense words
longagain:    meeepmoop]]
)