assertMessage(elemAt("abcd", 2), "b")
assertMessage(elemAt({1, 2, 3}, 2), 2)
assertMessage(elemAt(ovtable.init{{"a", 1}, {"b", 2}}, 1), 1)