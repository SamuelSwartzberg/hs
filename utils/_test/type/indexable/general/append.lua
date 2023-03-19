-- Test 1: Append to a string
local test_str = "hello"
local addition1 = " world"
local result1 = append(test_str, addition1)
assertMessage(result1, "hello world")

-- Test 2: Append to a list
local test_list = {1, 2, 3}
local addition2 = 4
local result2 = append(test_list, addition2)
assertMessage(result2, {1, 2, 3, 4})

-- Test 3: Append to an associative array
local test_assoc = {a = 1, b = 2, c = 3}
local addition3 = {"d", 4}
local result3 = append(test_assoc, addition3)
assertMessage(result3, {a = 1, b = 2, c = 3, d = 4})

-- Test 4: Append to an orderedtable
local ot = ovtable.new()
ot["a"] = 1
ot["b"] = 2
ot["c"] = 3
local addition4 = {"d", 4}
local result4 = append(ot, addition4)
local expected4 = ovtable.new()
expected4["a"] = 1
expected4["b"] = 2
expected4["c"] = 3
expected4["d"] = 4
assertMessage(result4, expected4)

-- Test 5: Append to an associative array without overwriting existing keys
local test_assoc_nooverwrite = {a = 1, b = 2, c = 3}
local addition5 = {"b", 4}
local result5 = append(test_assoc_nooverwrite, addition5, {nooverwrite = true})
assertMessage(result5, {a = 1, b = 2, c = 3})

-- Test 6: Append to an associative array with overwriting existing keys
local test_assoc_overwrite = {a = 1, b = 2, c = 3}
local addition6 = {"b", 4}
local result6 = append(test_assoc_overwrite, addition6, {nooverwrite = false})
assertMessage(result6, {a = 1, b = 4, c = 3})

-- Test 7: Attempt to append a non-pair to an associative array (should throw an error)
local test_assoc_err = {a = 1, b = 2, c = 3}
local addition7 = "non-pair"
local success, result7 = pcall(append, test_assoc_err, addition7)
assertMessage(success, false)

-- Test 8: Attempt to append to an unsupported type (should throw an error)
local test_unsupported = 42
local addition8 = "unsupported"
local success, result8 = pcall(append, test_unsupported, addition8)
assertMessage(success, false)
