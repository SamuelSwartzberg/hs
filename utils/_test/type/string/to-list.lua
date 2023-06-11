assertMessage(
  transf.string.chars("hello"),
  {"h", "e", "l", "l", "o"}
)

assertMessage(
  transf.string.chars(""),
  {}
)

assertMessage(
  transf.string.chars("😁"),
  {"😁"}
)

assertMessage(
  transf.string.chars("😁😁"),
  {"😁", "😁"}
)

assertMessage(
  transf.string.chars("😁~yaay~😁"),
  {"😁", "~", "y", "a", "a", "y", "~", "😁"}
)

assertMessage(
  transf.string.bytechars("hello"),
  {"h", "e", "l", "l", "o"}
)

assertMessage(
  transf.string.bytechars(""),
  {}
)

assertMessage(
  #transf.string.bytechars("😁"),
  4
)

assertMessage(
  #transf.string.bytechars("😁😁"),
  8
)

assertMessage(
  #transf.string.bytechars("😁~yaay~😁"),
  14
)

assertMessage(
  transf.string.lines("hello\nworld"),
  {"hello", "world"}
)

assertMessage(
  transf.string.lines("yo"),
  {"yo"}
)