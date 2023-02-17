assertMessage(
  containsLargeWhitespace("foo"),
  false
)

assertMessage(
  containsLargeWhitespace("foo\tbar"),
  true
)

assertMessage(
  containsLargeWhitespace("f\no\r\to"),
  true
)