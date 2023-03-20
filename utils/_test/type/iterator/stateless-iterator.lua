
assertMessage(
  iterToList(string.gmatch("abc", ".")),
  { "a", "b", "c" }
)

assertMessage(
  iterToList(string.gmatch("abc", "d")),
  {}
)

assertMessage(
  iterToTable(ipairs({"a", "b", "c"})),
  { "a", "b", "c" }
)

assertMessage(
  iterToTable(pairs({a = "a", b = "b", c = "c"})),
  { a = "a", b = "b", c = "c" }
)