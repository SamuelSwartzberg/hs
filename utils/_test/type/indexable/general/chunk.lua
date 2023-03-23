-- Test 2: Chunk a list
local test_list = {1, 2, 3, 4, 5, 6, 7, 8, 9}
local result2 = chunk(test_list, 4)
assertMessage(result2, {{1, 2, 3, 4}, {5, 6, 7, 8}, {9}})

-- Test 3: Chunk an orderedtable
local ot = ovtable.new()
ot["a"] = 1
ot["b"] = 2
ot["c"] = 3
ot["d"] = 4
ot["e"] = 5
ot["f"] = 6
ot["g"] = 7
local result3 = chunk(ot, 3)
local expected3 = {
  ovtable.init({{k="a",v=1}, {k="b",v=2}, {k="c",v=3}}),
  ovtable.init({{k="d",v=4}, {k="e",v=5}, {k="f",v=6}}),
  ovtable.init({{k="g",v=7}})
}
assertMessage(result3, expected3)

-- Test 5: Chunk a list with a size larger than the list length
local result5 = chunk(test_list, 15)
assertMessage(result5, {{1, 2, 3, 4, 5, 6, 7, 8, 9}})

-- Test 6: Chunk an orderedtable with a size larger than the orderedtable length
local result6 = chunk(ot, 10)
assertMessage(result6, {ot})
