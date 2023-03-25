assertMessage(elemAt("abcd", 2), "b")
assertMessage(elemAt("abcd", 2, "kv"), {2, "b"})
assertMessage(elemAt({1, 2, 3}, 2), 2)
assertMessage(elemAt({1, 2, 3}, 2, "kv"), {2, 2})
assertMessage(elemAt(ovtable.init{{"a", 1}, {"b", 2}}, 1), 1)
assertMessage(elemAt(ovtable.init{{"a", 1}, {"b", 2}}, 1, "kv"), {"a", 1})
local test_assoc = {
  c = "three",
  a = "one",
  d = "four",
  b = "two",
  e = "five",
}
assertMessage(elemAt(test_assoc, 3), "three")
assertMessage(elemAt(test_assoc, 3, "kv"), {3, "three"})