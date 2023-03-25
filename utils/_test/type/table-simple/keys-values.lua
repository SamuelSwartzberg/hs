local test_tbl = {
  a = "I",
  b = "II",
  c = "III",
}

assertMessage(
  ks(test_tbl),
  {"a", "b", "c"}
)

assertMessage(
  vls(test_tbl),
  {"I", "II", "III"}
)

local test_arr = {
  "I",
  "II",
  "III",
}

assertMessage(
  ks(test_arr),
  {1, 2, 3}
)

assertMessage(
  vls(test_arr),
  {"I", "II", "III"}
)

local test_ovtable = ovtable.init({
  { k = "one", v = "I" },
  { k = "two", v = "II" },
  { k = "three", v = "III" },
})

assertMessage(
  ks(test_ovtable),
  {"one", "two", "three"}
)

assertMessage(
  vls(test_ovtable),
  {"I", "II", "III"}
)
