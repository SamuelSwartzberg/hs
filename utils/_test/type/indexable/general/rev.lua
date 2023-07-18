assertMessage(transf.indexable.reversed_indexable("abcd"), "dcba")
assertMessage(transf.indexable.reversed_indexable({1, 2, 3}), {3, 2, 1})
assertMessage(transf.indexable.reversed_indexable(ovtable.init{{"a", 1}, {"b", 2}}), ovtable.init{{"b", 2}, {"a", 1}})