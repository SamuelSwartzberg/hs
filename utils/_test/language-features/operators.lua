assertMessage(
  ternary(true, 1, 2),
  1
)

assertMessage(
  ternary(false, 1, 2),
  2
)

assertMessage(
  defaultIfNil(1, 2),
  1
)

assertMessage(
  defaultIfNil(nil, 2),
  2
)

assertMessage(
  defaultIfNil(false, 2),
  false
)