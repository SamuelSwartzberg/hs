
local testtbl = {
  a = "恋",
  b = "爱",
  c = "是",
}


assertMessage(
  get.two_anys_stateful_generator.assoc_arr(transf.indexable.key_value_stateful_iter, testtbl),
  testtbl
)

assertMessage(
  get.any_stateful_generator.array(transf.indexable.key_value_stateful_iter, testtbl),
  {
    { "a", "恋" },
    { "b", "爱" },
    { "c", "是" },
  }
)