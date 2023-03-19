local ovtable = require "orderedtable"

-- Test 1: Simple splice on a list
local list1 = {1, 2, 3, 4, 5}
local list2 = {6, 7, 8}
local expectedResult1 = {1, 6, 7, 8, 2, 3, 4, 5}
local result1 = splice(list1, list2, 2)
assertMessage(result1, expectedResult1)

-- Test 2: Simple splice on a list with overwrite
local list1 = {1, 2, 3, 4, 5}
local list2 = {6, 7, 8}
local expectedResult2 = {1, 6, 7, 8, 5}
local result2 = splice(list1, list2, {start = 2, overwrite = true})
assertMessage(result2, expectedResult2)

-- Test 3: Splice at the end of a list
local list1 = {1, 2, 3, 4, 5}
local list2 = {6, 7, 8}
local expectedResult3 = {1, 2, 3, 4, 5, 6, 7, 8}
local result3 = splice(list1, list2, 6)
assertMessage(result3, expectedResult3)

-- Test 4: Splice at the beginning of a list
local list1 = {1, 2, 3, 4, 5}
local list2 = {6, 7, 8}
local expectedResult4 = {6, 7, 8, 1, 2, 3, 4, 5}
local result4 = splice(list1, list2, 1)
assertMessage(result4, expectedResult4)

-- Test 5: Splice with an empty list
local list1 = {1, 2, 3, 4, 5}
local list2 = {}
local expectedResult5 = {1, 2, 3, 4, 5}
local result5 = splice(list1, list2, 3)
assertMessage(result5, expectedResult5)

-- Test 6: Splice with an ordered table
local otable1 = ovtable.new()
otable1["a"] = 1
otable1["b"] = 2
otable1["c"] = 3

local otable2 = ovtable.new()
otable2["d"] = 4
otable2["e"] = 5

local expectedResult6 = ovtable.new()
expectedResult6["a"] = 1
expectedResult6["d"] = 4
expectedResult6["e"] = 5
expectedResult6["b"] = 2
expectedResult6["c"] = 3

local result6 = splice(otable1, otable2, {start = 2, nooverwrite = true})
assertMessage(result6, expectedResult6)

-- Test 7: Splice with an ordered table with overwrite
local otable1 = ovtable.new()
otable1["a"] = 1
otable1["b"] = 2
otable1["c"] = 3

local otable2 = ovtable.new()
otable2["d"] = 4
otable2["e"] = 5

local expectedResult7 = ovtable.new()
expectedResult7["a"] = 1
expectedResult7["d"] = 4
expectedResult7["e"] = 5

local result7 = splice(otable1, otable2, {start = 2, overwrite = true})
assertMessage(result7, expectedResult7)

-- Test 8: Splice with an ordered table at the beginning
local otable1 = ovtable.new()
otable1["a"] = 1
otable1["b"] = 2
otable1["c"] = 3

local otable2 = ovtable.new()
otable2["d"] = 4
otable2["e"] = 5

local expectedResult8 = ovtable.new()
expectedResult8["d"] = 4
expectedResult8["e"] = 5
expectedResult8["a"] = 1
expectedResult8["b"] = 2
expectedResult8["c"] = 3

local result8 = splice(otable1, otable2, 1)
assertMessage(result8, expectedResult8)

-- Test 9: Splice with an ordered table at the end
local otable1 = ovtable.new()
otable1["a"] = 1
otable1["b"] = 2
otable1["c"] = 3

local otable2 = ovtable.new()
otable2["d"] = 4
otable2["e"] = 5

local expectedResult9 = ovtable.new()
expectedResult9["a"] = 1
expectedResult9["b"] = 2
expectedResult9["c"] = 3
expectedResult9["d"] = 4
expectedResult9["e"] = 5

local result9 = splice(otable1, otable2, 4)
assertMessage(result9, expectedResult9)

-- Test 10: Splice with an ordered table and an empty ordered table
local otable1 = ovtable.new()
otable1["a"] = 1
otable1["b"] = 2
otable1["c"] = 3

local otable2 = ovtable.new()

local expectedResult10 = ovtable.new()
expectedResult10["a"] = 1
expectedResult10["b"] = 2
expectedResult10["c"] = 3

local result10 = splice(otable1, otable2, 2)
assertMessage(result10, expectedResult10)
