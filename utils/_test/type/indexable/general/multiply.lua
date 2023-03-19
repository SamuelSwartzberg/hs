
assertMessage(multiply("abc", 3), "abcabcabc")
assertMessage(multiply({1, 2, 3}, 2), {1, 2, 3, 1, 2, 3})
assertMessage(multiply(ovtable.init{{"a", 1}, {"b", 2}}, 2), ovtable.init{{"a", 1}, {"b", 2}, {"a", 1}, {"b", 2}})
