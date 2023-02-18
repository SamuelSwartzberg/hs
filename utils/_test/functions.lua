
assertValuesContainExactly(
  iteratorToList(string.gmatch("abc", ".")),
  { "a", "b", "c" }
)

assertTable(
  iteratorToList(string.gmatch("abc", "d")),
  {}
)

local returnTrueFsMemoized = fsmemoize(returnTrue, "returnTrue")
returnTrueFsMemoized()

assertMessage(
  returnTrueFsMemoized(),
  returnTrue()
)

local returnSameFsMemoized = fsmemoize(returnSame, "returnSame")
returnSameFsMemoized(1)

assertMessage(
  returnSameFsMemoized(1),
  returnSame(1)
)

returnSameFsMemoized({
  a = "a",
  b = "b"
})

assertTable(
  returnSameFsMemoized({
    a = "a",
    b = "b"
  }),
  {
    a = "a",
    b = "b"
  }
)

local returnSameNTimesFsMemoized = fsmemoize(returnSameNTimes, "returnSameNTimes")
returnSameNTimesFsMemoized("a", 3)

assertValuesContainExactly(
  {
    returnSameNTimesFsMemoized("a", 3)
  },
  {
    "a", "a", "a"
  }
)

local testtbl = {
  a = "恋",
  b = "爱",
  c = "是",
}


assertTable(
  statefulKeyIteratorToTable(spairs, testtbl),
  testtbl
)

assertValuesContainExactly(
  statefulNokeyIteratorToTable(spairs, testtbl),
  {
    { "a", "恋" },
    { "b", "爱" },
    { "c", "是" },
  }
)