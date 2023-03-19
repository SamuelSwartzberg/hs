-- Test 1: Basic split with a string separator
local test1_input = "hello,world,test"
local test1_sep = ","
local test1_expected = {"hello", "world", "test"}
local test1_result = split(test1_input, test1_sep)
assertMessage(test1_result, test1_expected)

-- Test 2a: Split list with one-element list
local test2_input = {"a", "b", "sep", "c", "sep", "d"}
local test2_sep = {"sep"}
local test2_expected = {{"a", "b"}, {"c"}, {"d"}}
local test2_result = split(test2_input, test2_sep)
assertMessage(test2_result, test2_expected)

-- Test 2: Split list with string
local test2_input = {"a", "b", "sep", "c", "sep", "d"}
local test2_sep = "sep"
local test2_expected = {{"a", "b"}, {"c"}, {"d"}}
local test2_result = split(test2_input, test2_sep)
assertMessage(test2_result, test2_expected)

-- Test 3: Split with "before" mode
local test3_input = "hello,world,test"
local test3_sep = ","
local test3_opts = {mode = "before"}
local test3_expected = {"hello", ",world", ",test"}
local test3_result = split(test3_input, test3_sep, test3_opts)
assertMessage(test3_result, test3_expected)

-- Test 4: Split with "after" mode
local test4_input = "hello,world,test"
local test4_sep = ","
local test4_opts = {mode = "after"}
local test4_expected = {"hello,", "world,", "test"}
local test4_result = split(test4_input, test4_sep, test4_opts)
assertMessage(test4_result, test4_expected)

-- Test 5: Split with custom condition (updated)
local test5_input = "apple.orange_banana!grape"
local test5_sep = {
  _r = "[._!]",
  _ignore_case = true
}
local test5_expected = {"apple", "orange", "banana", "grape"}
local test5_result = split(test5_input, test5_sep)
assertMessage(test5_result, test5_expected)

-- Test 6: Split with a list of conditions
local test6_input = "hello,world!test?example"
local test6_sep = {",", "!", "?"}
local test6_expected = {"hello", "world", "test", "example"}
local test6_result = split(test6_input, test6_sep)
assertMessage(test6_result, test6_expected)

-- Test 7: Split with empty input
local test7_input = ""
local test7_sep = ","
local test7_expected = {""}
local test7_result = split(test7_input, test7_sep)
assertMessage(test7_result, test7_expected)

-- Test 8: Split with no matching separator
local test8_input = "hello.world"
local test8_sep = ","
local test8_expected = {"hello.world"}
local test8_result = split(test8_input, test8_sep)
assertMessage(test8_result, test8_expected)

-- Test 9: Split an orderedtable (updated)
local ovtable = require "ovtable"
local test9_input = ovtable.init({{k = "a", v = 1}, {k = "s1", v = "sep"}, {k = "b", v = 3}, {k = "s2", v = "sep"}, {k = "c", v = 5}})
local test9_sep = "sep"
local test9_expected = {
  ovtable.init({{k = "a", v = 1}}),
  ovtable.init({{k = "b", v = 3}}),
  ovtable.init({{k = "c", v = 5}})
}
local test9_result = split(test9_input, test9_sep)
assertMessage(test9_result, test9_expected)
