-- Test longestCommonPrefix
assertMessage(longestCommonPrefix({"hello", "heaven", "heavy"}), "he")
assertMessage(longestCommonPrefix({{1, 2, 3}, {1, 2, 4}, {1, 2, 5}}), {1, 2})
assertMessage(longestCommonPrefix({ovtable.init{{"a", 1}, {"b", 2}}, ovtable.init{{"a", 1}, {"c", 3}}}), ovtable.init{{"a", 1}})

assertMessage(longestCommonPrefix({"perfectly", "lylyly", "bit.ly"}, {rev=true}), "ly")
assertMessage(longestCommonPrefix({{3, 2, 1}, {4, 2, 1}, {5, 2, 1}}, {rev=true}), {2, 1})
assertMessage(longestCommonPrefix({ovtable.init{{"a", 1}, {"b", 2}}, ovtable.init{{"c", 3}, {"b", 2}}}, {rev=true}), ovtable.init{{"b", 2}})