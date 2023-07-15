assertMessage(transf.indexable.length("abcd"), 4)
assertMessage(transf.indexable.length({1, 2, 3}), 3)
assertMessage(transf.indexable.length(ovtable.init{{"a", 1}, {"b", 2}}), 2)