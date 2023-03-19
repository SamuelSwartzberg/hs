assertMessage(rev("abcd"), "dcba")
assertMessage(rev({1, 2, 3}), {3, 2, 1})
assertMessage(rev(ovtable.init{{"a", 1}, {"b", 2}}), ovtable.init{{"b", 2}, {"a", 1}})