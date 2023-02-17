assertMessage(
  asciiStringContainsSome("foo", {"f"}),
  true
)

assertMessage(
  asciiStringContainsSome("foo", {"f", "o"}),
  true
)

assertMessage(
  asciiStringContainsSome("foo", {"x", "f"}),
  true
)

assertMessage(
  asciiStringContainsSome("foo", {"x", "y"}),
  false
)