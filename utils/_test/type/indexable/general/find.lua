
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
  find({"foo", "bar", "baz"}, "bar", "v"),
  "bar"
)

assertMessage(
  find({"foo", "bar", "baz"}, "qux", "v"),
  nil
)

assertMessage(
  find(
    { 1, 2, 3 },
    function(value) return value == 2 end,
    "v"
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
--[[ temporarily disabled because I need to test concat separately first
assertMessage(
  find(
    { 2, 7, 9, 1, 3, 2, 5, 1, 2, 9 },
    2,
    { findall = true, args = "v", ret = "k" }
  ),
  { 1, 6, 9 }
)

assertMessage(
  find(
    { 2, 7, 9, 1, 3, 2, 5, 1, 2, 9 },
    2,
    { findall = true, args = "v", ret = "v" }
  ),
  { 2, 2, 2 }
)

assertMessage(
  find(
    { 2, 7, 9, 1, 3, 2, 5, 1, 2, 9 },
    2,
    { findall = true, args = "v", ret = "kv" }
  ),
  { { 1, 2 }, { 6, 2 }, { 9, 2 } }
)

assertMessage(
  find(
    { 2, 7, 9, 1, 3, 2, 5, 1, 2, 9 },
    2,
    { findall = true, args = "v", ret = "kv", start = 2 }
  ),
  { { 6, 2 }, { 9, 2 } }
)

assertMessage(
  find(
    { 2, 7, 9, 1, 3, 2, 5, 1, 2, 9 },
    2,
    { findall = true, args = "v", ret = "kv", stop = 8 }
  ),
  { { 1, 2 }, { 6, 2 } }
)
 ]]
assertMessage(
  {find(
    "somestr",
    {_contains = "str"},
    { "v", "kv"}
  )},
  { 5, "str" }
)