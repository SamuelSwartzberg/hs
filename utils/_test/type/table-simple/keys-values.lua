local test_tbl = {
  a = "I",
  b = "II",
  c = "III",
}

assertMessage(
  transf.indexable.key_array(test_tbl),
  {"a", "b", "c"}
)

assertMessage(
  transf.indexable.value_array(test_tbl),
  {"I", "II", "III"}
)

local test_arr = {
  "I",
  "II",
  "III",
}

assertMessage(
  transf.indexable.key_array(test_arr),
  {1, 2, 3}
)

assertMessage(
  transf.indexable.value_array(test_arr),
  {"I", "II", "III"}
)

local test_ovtable = ovtable.init({
  { k = "one", v = "I" },
  { k = "two", v = "II" },
  { k = "three", v = "III" },
})

assertMessage(
  transf.indexable.key_array(test_ovtable),
  {"one", "two", "three"}
)

assertMessage(
  transf.indexable.value_array(test_ovtable),
  {"I", "II", "III"}
)
