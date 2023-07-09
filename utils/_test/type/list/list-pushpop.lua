local abc  = { "a", "b", "c" }

dothis.array.push(abc, "d")

assertMessage(
  abc,
  {"a", "b", "c", "d"}
)

assertMessage(
  dothis.array.pop(abc),
  "d"
)

assertMessage(
  abc,
  {"a", "b", "c"}
)