
assertValuesContainExactly(
  iterToList(string.gmatch("abc", ".")),
  { "a", "b", "c" }
)

assertMessage(
  iterToList(string.gmatch("abc", "d")),
  {}
)

local returnTrueFsMemoized = memoize(returnTrue, {
  mode = "fs"
})
returnTrueFsMemoized()

assertMessage(
  returnTrueFsMemoized(),
  returnTrue()
)

local returnSameFsMemoized = memoize(returnSame, {
  mode = "fs"
})
returnSameFsMemoized(1)

assertMessage(
  returnSameFsMemoized(1),
  returnSame(1)
)

returnSameFsMemoized({
  a = "a",
  b = "b"
})

assertMessage(
  returnSameFsMemoized({
    a = "a",
    b = "b"
  }),
  {
    a = "a",
    b = "b"
  }
)

local returnSameNTimesFsMemoized = memoize(returnSameNTimes, {
  mode = "fs"
})
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


assertMessage(
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