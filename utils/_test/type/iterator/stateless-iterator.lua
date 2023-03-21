
assertMessage(
  iterToTbl({tolist=true, ret="v"},string.gmatch("abc", ".")),
  { "a", "b", "c" }
)

assertMessage(
  iterToTbl({tolist=true, ret="v"},string.gmatch("abc", "d")),
  {}
)

assertMessage(
  iterToTbl({noovtable=true},ipairs({"a", "b", "c"})),
  { "a", "b", "c" }
)

assertMessage(
  iterToTbl(pairs({a = "a", b = "b", c = "c"})),
  { a = "a", b = "b", c = "c" }
)