assertMessage(
  slice({1,2,3}, 1),
  {1,2,3}
)

assertMessage(
  slice({1,2,3}, 2),
  {2,3}
)

assertMessage(
  slice({1,2,3}, 4),
  {}
)

assertMessage(
  slice({1,2,3}, 1, 1),
  {1}
)

assertMessage(
  slice({1,2,3}, 1, 2),
  {1,2}
)

assertMessage(
  slice({1,2,3}, 1, 4),
  {1,2,3}
)

assertMessage(
  slice({1,2,3}, 2, 1),
  {}
)

assertMessage(
  slice({1,2,3}, 1, -1),
  {1,2,3}
)

assertMessage(
  slice({1,2,3}, 1, -2),
  {1,2}
)

assertMessage(
  slice({1,2,3}, 2, -1),
  {2,3}
)

assertMessage(
  slice({1,2,3}, nil, 3),
  {1,2,3}
)

assertMessage(
  slice({1,2,3}, 1, nil),
  {1,2,3}
)

assertMessage(
  slice({1,2,3}),
  {1,2,3}
)

assertMessage(
  slice({1,2,3}, 1, nil, 2),
  {1,3}
)

assertMessage(
  slice({1,2,3}, 2, nil, 2),
  {2}
)

assertMessage(
  slice({1,2,3}, 1, nil, 3),
  {1}
)

-- Test 1: Basic slice on a string
local test_str = "hello world"
local result1 = slice(test_str, 1, 5)
assertMessage(result1, "hello")

-- Test 2: Basic slice on a table
local test_tbl = {"a", "b", "c", "d", "e"}
local result2 = slice(test_tbl, 2, 4)
assertMessage(result2, {"b", "c", "d"})

-- Test 2b: Basic slice on an assoc arr
local test_assoc = assoc({a = 1, b = 2, c = 3, d = 4, e = 5})

local result2b = slice(test_assoc, 2, 4)
assertMessage(result2b, assoc({b = 2, c = 3, d = 4}))

-- Test 3: Basic slice with negative indices on a string
local result3 = slice(test_str, -5, -1)
assertMessage(result3, "world")

-- Test 4: Basic slice with negative indices on a table
local result4 = slice(test_tbl, -3, -1)
assertMessage(result4, {"c", "d", "e"})

-- Test 4b: Basic slice with negative indices on an assoc arr
local result4b = slice(test_assoc, -3, -1)
assertMessage(result4b, assoc({c = 3, d = 4, e = 5}))

-- Test 5: Slice with a step on a string
local result5 = slice(test_str, 1, 10, 2)
assertMessage(result5, "hlowr")

-- Test 6: Slice with a step on a table
local result6 = slice(test_tbl, 1, 5, 2)
assertMessage(result6, {"a", "c", "e"})

-- Test 6b: Slice with a step on an assoc arr
local result5b = slice(test_assoc, 1, 5, 2)
assertMessage(result5b, assoc({a = 1, c = 3, e = 5}))

-- Test 7: Slice using a sliceSpec string on a string
local result7 = slice(test_str, "1:5")
assertMessage(result7, "hello")

-- Test 8: Slice using a sliceSpec string on a table
local result8 = slice(test_tbl, "2:4")
assertMessage(result8, {"b", "c", "d"})

-- Test 8b: Slice using a sliceSpec string on an assoc arr
local result8b = slice(test_assoc, "2:4")
assertMessage(result8b, assoc({b = 2, c = 3, d = 4}))

-- Test 9: Slice using a conditionSpec on a string
local result9 = slice(test_str, {start = {_contains = "e"}, stop = 5})
assertMessage(result9, "ello")

-- Test 10: Slice using a conditionSpec on a table
local result10 = slice(test_tbl, {start = {_exactly = "a", _invert = true}, stop = 4})
assertMessage(result10, {"b", "c", "d"})

-- Test 10b: Slice using a conditionSpec on an assoc arr
local result10b = slice(test_assoc, {start = {_exactly = 2}, stop = 4}) -- the fact that {_exactly = 2} is identical to the index 2 is a coincidence
assertMessage(result10b, assoc({b = 2, c = 3, d = 4}))

-- Test 11: Slice with a step and negative indices on a string
local result11 = slice(test_str, -10, -1, 2)
assertMessage(result11, "el ol")

-- negative step

assertMessage(
  slice(test_tbl, -1, 1, -1),
  {"e", "d", "c", "b", "a"}
)

-- Test 12: Slice with a step and negative indices on a table
local result12 = slice(test_tbl, -5, -1, 2)
assertMessage(result12, {"a", "c", "e"})

-- Test 16: Slice using sliced_indicator on a string
local result16 = slice(test_str, {start = 1, stop = 5, sliced_indicator = "..."})
assertMessage(result16, "hello...")

-- Test 17: Slice using sliced_indicator on a table
local result17 = slice(test_tbl, {start = 2, stop = 4, sliced_indicator = "sliced"})
assertMessage(result17, {"sliced", "b", "c", "d", "sliced"})

-- Test 18: Slice using fill on a string
local result18 = slice(test_str, {start = 1, stop = 5, step = 2, fill = "_"})
assertMessage(result18, "hlo______") -- currently, fill doesn't fill holes created by step, only before/after the slice. This may change in the future, in which case this test will fail and need to be updated. For now, this is the expected behavior.

-- Test 19: Slice using fill on a table
local result19 = slice(test_tbl, {start = 2, stop = 4, fill = "x"})
assertMessage(result19, { "x", "b", "c", "d", "x" })

-- Test 20: Slice using last_start and last_stop on a string
local result20 = slice(test_str, {start = {_r = "l"}, last_start = true, stop = {_r = "o"}, last_stop = false})
assertMessage(result20, "llo")

-- Test 21: Slice using last_start and last_stop on a table
local result21 = slice({"b", "a", "b", "a", "d", "d", "c"}, {start = {_exactly = "a"}, last_start = true, stop = {_exactly = "d"}, last_stop = true})
assertMessage(result21, {"a", "d", "d"})

-- Test 22: Slice using sliced_indicator and fill on a string
local result22 = slice(test_str, {start = 3, stop = 9, fill = "_", sliced_indicator = "..."})
assertMessage(result22, "...__llo wor__...")

-- Test 23: Slice using sliced_indicator and fill on a table
local result23 = slice(test_tbl, {start = 2, stop = 5, fill = "x", sliced_indicator = "sliced"})
assertMessage(result23, {"sliced", "x", "b", "c", "d", "e"})