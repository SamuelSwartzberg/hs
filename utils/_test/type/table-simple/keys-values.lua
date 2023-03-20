local test_tbl = {
  a = "I",
  b = "II",
  c = "III",
}

assertMessage(
  keys(test_tbl),
  {"a", "b", "c"}
)

assertMessage(
  values(test_tbl),
  {"I", "II", "III"}
)

local test_arr = {
  "I",
  "II",
  "III",
}

assertMessage(
  keys(test_arr),
  {1, 2, 3}
)

assertMessage(
  values(test_arr),
  {"I", "II", "III"}
)

local test_ovtable = ovtable.init({
  { k = "one", v = "I" },
  { k = "two", v = "II" },
  { k = "three", v = "III" },
})

assertMessage(
  keys(test_ovtable),
  {"one", "two", "three"}
)

assertMessage(
  values(test_ovtable),
  {"I", "II", "III"}
)
