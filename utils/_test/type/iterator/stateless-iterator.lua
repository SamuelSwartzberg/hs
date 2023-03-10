
assertValuesContainExactly(
  iterToList(string.gmatch("abc", ".")),
  { "a", "b", "c" }
)

assertMessage(
  iterToList(string.gmatch("abc", "d")),
  {}
)
