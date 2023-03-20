-- Test 1: Basic replacement
local t1 = {"apple", "banana", "carrot", "dog", "elephant"}
local t1_result = replace(t1, {cond = "banana", mode = "replace", proc = "fruit"})
assertMessage(t1_result[2], "fruit")

-- Test 2: Insert before
local t2 = {"apple", "banana", "carrot", "dog", "elephant"}
local t2_result = replace(t2, {cond = "carrot", mode = "before", proc = "vegetable"})
assertMessage(t2_result[3], "vegetable")

-- Test 3: Insert after
local t3 = {"apple", "banana", "carrot", "dog", "elephant"}
local t3_result = replace(t3, {cond = "dog", mode = "after", proc = "animal"})
assertMessage(t3_result[5], "animal")

-- Test 4: Remove element
local t4 = {"apple", "banana", "carrot", "dog", "elephant"}
local t4_result = replace(t4, {cond = "carrot", mode = "remove"})
assertMessage(#t4_result, 4)

-- Test 5: Replace multiple elements with different conditions and procs
local t5 = {"apple", "banana", "carrot", "dog", "elephant"}
local t5_result = replace(t5, {
    {cond = "banana", mode = "replace", proc = "fruit"},
    {cond = "carrot", mode = "replace", proc = "vegetable"},
})
assertMessage(t5_result[2], "fruit")
assertMessage(t5_result[3], "vegetable")

-- Test 6: Replace with a condition using _contains
local t6 = {"apple", "banana", "carrot", "dog", "elephant"}
local t6_result = replace(t6, {cond = {_contains = "a"}, mode = "replace", proc = "contains_a"})
for _, v in ipairs(t6_result) do
    if v == "dog" then
        error("dog should not be replaced")
    elseif v ~= "contains_a" and v ~= "dog" then
        error("unexpected value in result")
    end
end


-- Test 7: Replace with a function processor
local t7 = {"apple", "banana", "carrot", "dog", "elephant"}
local t7_result = replace(t7, {cond = "banana", mode = "replace", proc = function(v) return v:upper() end})
assertMessage(t7_result[2], "BANANA")

-- Test 8: Replace with a table processor
local t8 = {"apple", "banana", "carrot", "dog", "elephant"}
local t8_result = replace(t8, {proc = {apple = "fruit", dog = "animal"}})
assertMessage(t8_result[1], "fruit")
assertMessage(t8_result[4], "animal")

-- Test 9: Replace with a string processor and custom arguments
local t9 = {"apple", "banana", "carrot", "dog", "elephant"}
local t9_result = replace(t9, {cond = "banana", mode = "replace", proc = {_f = "%s_ed"}, args = "v"})
assertMessage(t9_result[2], "banana_ed")

-- Test 11: Replace with a list processor and custom return arguments
local t11 = {"apple", "banana", "carrot", "dog", "elephant"}
local t11_result = replace(t11, {cond = "banana", mode = "replace", proc = {"fruit", "modified"}, ret = "v"})
assertMessage(t11_result[2], "fruit")

-- Test 12: Replace using conditionProcSpecParallelList
local t12 = {"apple", "banana", "carrot", "dog", "elephant"}
local t12_result = replace(t12, {{"apple", "carrot"}, {"fruit", "vegetable"}})
assertMessage(t12_result[1], "fruit")
assertMessage(t12_result[3], "vegetable")

-- Test 13: Replace with a condition using _invert
local t13 = {"apple", "banana", "carrot", "dog", "elephant"}
local t13_result = replace(t13, {cond = {_r = "a", _invert = true}, mode = "replace", proc = "no_a"})
for _, v in ipairs(t13_result) do
    if v == "apple" or v == "banana" or v == "carrot" or v == "elephant" then
        error("a-containing item should be replaced")
    elseif v ~= "no_a" and v ~= "dog" then
        error("unexpected value in result")
    end
end

-- Test 14: Replace using globalopts
local t14 = {"apple", "banana", "carrot", "dog", "elephant"}
local t14_result = replace(t14, {{"apple", "carrot"}, {"fruit", "vegetable"}}, {mode = "replace"})
assertMessage(t14_result[1], "fruit")
assertMessage(t14_result[3], "vegetable")


-- Test 15: Replace using conditionProcSpecPair
local t15 = {"apple", "banana", "carrot", "dog", "elephant"}
local t15_result = replace(t15, { {"apple", "fruit"}, {"carrot", "vegetable"} })
assertMessage(t15_result[1], "fruit")
assertMessage(t15_result[3], "vegetable")

-- Test 16: Replace with args set to 'k'
local ot16 = ovtable.init({ {key = "apple", value = 1}, {key = "banana", value = 2} })
local ot16_result = replace(ot16, {cond = {_type = "number"}, mode = "replace", proc = rev, args = "k"})
assertMessage(ot16_result.elppa, 1)
assertMessage(ot16_result.ananab, 2)

-- Tests for strings
-- Test 17: Replace with a string
local s17 = "apple,banana,carrot,dog,elephant"
local s17_result = replace(s17, {cond = "banana", mode = "replace", proc = "fruit"})
assertMessage(s17_result, "apple,fruit,carrot,dog,elephant")

-- Test 18: Replace with a condition using _contains for strings
local s18 = "apple,ban"
local s18_result = replace(s18, {cond = {_contains = "a"}, mode = "replace", proc = "contains_a"})
assertMessage(s18_result, "contains_apple,bcontains_an")

-- Tests for orderedtables
-- Test 19: Replace with an orderedtable
local ot19 = ovtable.init({ {key = "apple", value = 1}, {key = "banana", value = 2} })
local ot19_result = replace(ot19, {cond = {_type = "number"}, mode = "replace", proc = "3"})
assertMessage(ot19_result:getindex("apple"), "3")
assertMessage(ot19_result:getindex("banana"), "3")

-- Test 20: Replace with a condition using _contains for orderedtables
local ot20 = ovtable.init({ {key = "apple", value = "fruit"}, {key = "banana", value = "fruit"}, {key = "carrot", value = "vegetable"} })
local ot20_result = replace(ot20, {cond = {_contains = "fruit"}, mode = "replace", proc = "tasty_fruit"})
assertMessage(ot20_result:getindex("apple"), "tasty_fruit")
assertMessage(ot20_result:getindex("banana"), "tasty_fruit")
assertMessage(ot20_result:getindex("carrot"), "vegetable")