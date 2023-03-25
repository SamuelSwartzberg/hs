local test_ovtable = ovtable.init({
  { k = "I", v = "one" },
  { k = "II", v = "two" },
  { k = "III", v = "three" },
  { k = "IV", v = "four" },
  { k = "V", v = "five" },
})

local test_list = {
  "one",
  "two",
  "three",
  "four",
  "five",
}

local test_assoc = {
  c = "three",
  a = "one",
  d = "four",
  b = "two",
  e = "five",
}
local manual_counter_arbitrary = 2

assertMessage(
  getIndex(test_ovtable, "III",  manual_counter_arbitrary),
  3
)

assertMessage(
  getIndex(test_list, 3, manual_counter_arbitrary),
  3
)

assertMessage(
  getIndex(test_assoc, "c", manual_counter_arbitrary),
  2
)