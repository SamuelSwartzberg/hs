local abc  = { "a", "b", "c" }

push(abc, "d")

assertMessage(
  abc,
  {"a", "b", "c", "d"}
)

assertMessage(
  pop(abc),
  "d"
)

assertMessage(
  abc,
  {"a", "b", "c"}
)