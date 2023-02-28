
assertMessage(
  replace("a.b"),
  "a%.b"
)

assertMessage(
  replace("^[^a-n]+%.%.\\$"),
  "%^%[%^a%-n%]%+%%%.%%%.\\%$"
)
