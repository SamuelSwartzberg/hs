local test_tbl = {
  a = "I",
  b = "II",
  c = "III",
}

assertValuesContainExactly(
  keys(test_tbl),
  {"a", "b", "c"}
)

assertValuesContainExactly(
  values(test_tbl),
  {"I", "II", "III"}
)

local test_arr = {
  "I",
  "II",
  "III",
}

assertValuesContainExactly(
  keys(test_arr),
  {1, 2, 3}
)

assertValuesContainExactly(
  values(test_arr),
  {"I", "II", "III"}
)

local test_ovtable = ovtable.init({
  { k = "one", v = "I" },
  { k = "two", v = "II" },
  { k = "three", v = "III" },
})

assertValuesContainExactly(
  keys(test_ovtable),
  {"one", "two", "three"}
)

assertValuesContainExactly(
  values(test_ovtable),
  {"I", "II", "III"}
)
