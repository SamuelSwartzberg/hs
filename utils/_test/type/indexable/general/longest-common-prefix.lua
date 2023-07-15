-- Test transf.indexable_array.longest_common_prefix_indexable_array
assertMessage(transf.indexable_array.longest_common_prefix_indexable({"hello", "heaven", "heavy"}), "he")
assertMessage(transf.indexable_array.longest_common_prefix_indexable({{1, 2, 3}, {1, 2, 4}, {1, 2, 5}}), {1, 2})
assertMessage(transf.indexable_array.longest_common_prefix_indexable({ovtable.init{{"a", 1}, {"b", 2}}, ovtable.init{{"a", 1}, {"c", 3}}}), ovtable.init{{"a", 1}})

assertMessage(transf.indexable_array.longest_common_suffix_indexable({"perfectly", "lylyly", "bit.ly"}), "ly")
assertMessage(transf.indexable_array.longest_common_suffix_indexable({{3, 2, 1}, {4, 2, 1}, {5, 2, 1}}), {2, 1})
assertMessage(transf.indexable_array.longest_common_suffix_indexable({ovtable.init{{"a", 1}, {"b", 2}}, ovtable.init{{"c", 3}, {"b", 2}}}), ovtable.init{{"b", 2}})