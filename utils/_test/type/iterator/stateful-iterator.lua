
local testtbl = {
  a = "恋",
  b = "爱",
  c = "是",
}


assertMessage(
  statefulKeyIteratorToTable(sprs, testtbl),
  testtbl
)

assertMessage(
  statefulNokeyIteratorToTable(sprs, testtbl),
  {
    { "a", "恋" },
    { "b", "爱" },
    { "c", "是" },
  }
)