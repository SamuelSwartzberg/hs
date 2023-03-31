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
local test2_input = {"a", "b", "sep", "c", "d", "sep", "d"}
local test2_sep = "sep"
local test2_expected = {{"a", "b"}, {"c", "d"}, {"d"}}
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
local test5_input = "apple;orange_banana,grape"
local test5_sep = {
  _r = "[;_,]",
  _ignore_case = true
}
local test5_expected = {"apple", "orange", "banana", "grape"}
local test5_result = split(test5_input, test5_sep)
assertMessage(test5_result, test5_expected)

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
local test9_input = ovtable.init({
  {k = "a", v = 1}, 
  {k = "s1", v = "sep"}, 
  {k = "b", v = 3}, 
  {k = "s2", v = "sep"}, 
  {k = "c", v = 5}
})
local test9_sep = "sep"
local test9_expected = {
  ovtable.init({{k = "a", v = 1}}),
  ovtable.init({{k = "b", v = 3}}),
  ovtable.init({{k = "c", v = 5}})
}
local test9_result = split(test9_input, test9_sep)
assertMessage(test9_result, test9_expected)


-- Test 10: Split list with string and "before" mode

local test10_input = {"a", "b", "sep", "c", "d", "sep", "d"}
local test10_sep = "sep"
local test10_result = split(test10_input, test10_sep, {mode = "before"})
local test10_expected = {{"a", "b"}, {"sep", "c", "d"}, {"sep", "d"}}
assertMessage(test10_result, test10_expected)

-- Test 11: Split list with string and "after" mode
local test11_input = {"a", "b", "sep", "c", "d", "sep", "d"}
local test11_sep = "sep"
local test11_result = split(test11_input, test11_sep, {mode = "after"})
local test11_expected = {{"a", "b", "sep"}, {"c", "d", "sep"}, {"d"}}
assertMessage(test11_result, test11_expected)

-- Test 12: Split string with condition which would match each element if it was matching chars individually

assertMessage(
  split(
    "foo",
    {_r = "."},
    {mode = "after", limit = 1}
  ),
  {"f", "oo"} -- definitely not {"f", "o", "o"}
)

-- Test 13: Split assoc arr 

assertMessage(
  split(
    {
      a = "foo",
      b = "bar",
      c = "baz",
      d = "foo",
      e = "bar",
    },
    {_exactly = "baz"},
    {mode = "remove"}
  ),
  {
    {
      a = "foo",
      b = "bar",
    },
    {
      d = "foo",
      e = "bar",
    }
  }
)

-- Test 14: Split assoc arr with with "before" mode

assertMessage(
  split(
    {
      a = "foo",
      b = "bar",
      c = "baz",
      d = "foo",
      e = "bar",
    },
    {_exactly = "baz"},
    {mode = "before"}
  ),
  {
    {
      a = "foo",
      b = "bar",
    },
    {
      c = "baz",
      d = "foo",
      e = "bar",
    }
  }
)

-- Test 15: Split assoc arr with with "after" mode

assertMessage(
  split(
    {
      a = "foo",
      b = "bar",
      c = "baz",
      d = "foo",
      e = "bar",
    },
    {_exactly = "baz"},
    {mode = "after"}
  ),
  {
    {
      a = "foo",
      b = "bar",
      c = "baz",
    },
    {
      d = "foo",
      e = "bar",
    }
  }
)

-- Test 16: Split assoc arr on index

assertMessage(
  split(
    {
      a = "foo",
      b = "bar",
      c = "baz",
      d = "foo",
      e = "bar",
    },
    function(i)
      return i % 2 == 0
    end,
    {mode = "remove", findopts = {args = "i"}}
  ),
  {
    {
      a = "foo",
    },
    {
      c = "baz",
    },
    {
      e = "bar",
    }
  }
)