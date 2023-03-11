local abc  = { "a", "b", "c" }

push(abc, "d")

assertValuesContainExactly(
  abc,
  {"a", "b", "c", "d"}
)

assertMessage(
  pop(abc),
  "d"
)

assertValuesContainExactly(
  abc,
  {"a", "b", "c"}
)