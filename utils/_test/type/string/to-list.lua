assertValuesContainExactly(
  chars("hello"),
  {"h", "e", "l", "l", "o"}
)

assertValuesContainExactly(
  chars(""),
  {}
)

assertValuesContainExactly(
  chars("😁"),
  {"😁"}
)

assertValuesContainExactly(
  chars("😁😁"),
  {"😁", "😁"}
)

assertValuesContainExactly(
  chars("😁~yaay~😁"),
  {"😁", "~", "y", "a", "a", "y", "~", "😁"}
)

assertValuesContainExactly(
  bytechars("hello"),
  {"h", "e", "l", "l", "o"}
)

assertValuesContainExactly(
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

assertValuesContainExactly(
  lines("hello\nworld"),
  {"hello", "world"}
)

assertValuesContainExactly(
  lines("yo"),
  {"yo"}
)