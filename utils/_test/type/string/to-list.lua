assertMessage(
  chars("hello"),
  {"h", "e", "l", "l", "o"}
)

assertMessage(
  chars(""),
  {}
)

assertMessage(
  chars("😁"),
  {"😁"}
)

assertMessage(
  chars("😁😁"),
  {"😁", "😁"}
)

assertMessage(
  chars("😁~yaay~😁"),
  {"😁", "~", "y", "a", "a", "y", "~", "😁"}
)

assertMessage(
  bytechars("hello"),
  {"h", "e", "l", "l", "o"}
)

assertMessage(
  bytechars(""),
  {}
)

assertMessage(
  #bytechars("😁"),
  4
)

assertMessage(
  #bytechars("😁😁"),
  8
)

assertMessage(
  #bytechars("😁~yaay~😁"),
  14
)

assertMessage(
  lines("hello\nworld"),
  {"hello", "world"}
)

assertMessage(
  lines("yo"),
  {"yo"}
)