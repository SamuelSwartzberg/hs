
assertValuesContainExactly(
  iterToList(string.gmatch("abc", ".")),
  { "a", "b", "c" }
)

assertMessage(
  iterToList(string.gmatch("abc", "d")),
  {}
)

assertValuesContainExactly(
  iterToTable(ipairs({"a", "b", "c"})),
  { "a", "b", "c" }
)

assertValuesContainExactly(
  iterToTable(pairs({a = "a", b = "b", c = "c"})),
  { a = "a", b = "b", c = "c" }
)