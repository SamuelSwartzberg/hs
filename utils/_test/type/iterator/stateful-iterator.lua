
local testtbl = {
  a = "恋",
  b = "爱",
  c = "是",
}


assertMessage(
  get.a_and_b_stateful_generator.assoc_arr(sprs, testtbl),
  testtbl
)

assertMessage(
  get.any_stateful_generator.array(sprs, testtbl),
  {
    { "a", "恋" },
    { "b", "爱" },
    { "c", "是" },
  }
)