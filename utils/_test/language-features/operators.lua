assertMessage(
  ternary(true, 1, 2),
  1
)

assertMessage(
  ternary(false, 1, 2),
  2
)

assertMessage(
  get.any.default_if_nil(1, 2),
  1
)

assertMessage(
  get.any.default_if_nil(nil, 2),
  2
)

assertMessage(
  get.any.default_if_nil(false, 2),
  false
)

