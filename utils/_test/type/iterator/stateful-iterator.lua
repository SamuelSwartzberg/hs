
local testtbl = {
  a = "恋",
  b = "爱",
  c = "是",
}


assertMessage(
  statefulKeyIteratorToTable(spairs, testtbl),
  testtbl
)

assertMessage(
  statefulNokeyIteratorToTable(spairs, testtbl),
  {
    { "a", "恋" },
    { "b", "爱" },
    { "c", "是" },
  }
)