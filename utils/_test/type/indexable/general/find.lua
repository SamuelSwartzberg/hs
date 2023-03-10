
assertMessage(
  find({"foo", "bar", "baz"}, "bar"),
  true
)

assertMessage(
  find({"foo", "bar", "baz"}, "qux"),
  false
)

assertMessage(
  find({ a = 1, b = 2, c = 3 }, 2),
  true
)

assertMessage(
  find({ a = 1, b = 2, c = 3 }, "b"),
  false
)

assertMessage(
  find({"foo", "bar", "baz"}, "bar"),
  "bar"
)

assertMessage(
  find({"foo", "bar", "baz"}, "qux"),
  nil
)

assertMessage(
  find(
    { 1, 2, 3 },
    function(value) return value == 2 end
  ),
  2
)

assertMessage(
  find(
    { a = 1, b = 2, c = 3 },
    2,
    {"v", "k"}
  ),
  "b"
)
