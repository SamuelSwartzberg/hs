-- Test 1: Basic replacement
local t1 = {"apple", "banana", "carrot", "dog", "elephant"}
local t1_result = replace(t1, {cond = "banana", mode = "replace", proc = "fruit"})
assertMessage(t1_result, {"apple", "fruit", "carrot", "dog", "elephant"})

-- Test 2: Insert before
local t2 = {"apple", "banana", "carrot", "dog", "elephant"}
local t2_result = replace(t2, {cond = "carrot", mode = "before", proc = "vegetable"})
assertMessage(t2_result, {"apple", "banana", "vegetable", "carrot", "dog", "elephant"})

-- Test 3: Insert after
local t3 = {"apple", "banana", "carrot", "dog", "elephant"}
local t3_result = replace(t3, {cond = "dog", mode = "after", proc = "animal"})
assertMessage(t3_result, {"apple", "banana", "carrot", "dog", "animal", "elephant"})

-- Test 4: Remove element
local t4 = {"apple", "banana", "carrot", "dog", "elephant"}
local t4_result = replace(t4, {cond = "carrot", mode = "remove"})
assertMessage(t4_result, {"apple", "banana", "dog", "elephant"})

-- Test 5: Replace multiple elements with different conditions and procs
local t5 = {"apple", "banana", "carrot", "dog", "elephant"}
local t5_result = replace(t5, {
    {cond = "banana", mode = "replace", proc = "fruit"},
    {cond = "carrot", mode = "replace", proc = "vegetable"},
})
assertMessage(t5_result, {"apple", "fruit", "vegetable", "dog", "elephant"})

-- Test 6: Replace with a condition using _contains
local t6 = {"apple", "banana", "carrot", "dog", "elephant"}
local t6_result = replace(t6, {cond = {_contains = "a"}, mode = "replace", proc = "contains_a"})
assertMessage(t6_result, {"contains_a", "contains_a", "contains_a", "dog", "contains_a"})


-- Test 7: Replace with a function processor
local t7 = {"apple", "banana", "carrot", "dog", "elephant"}
local t7_result = replace(t7, {cond = "banana", mode = "replace", proc = function(v) 
    return v:upper() end})
assertMessage(t7_result, {"apple", "BANANA", "carrot", "dog", "elephant"}) 

-- Test 8: Replace with a table processor
local t8 = {"apple", "banana", "carrot", "dog", "elephant"}
local t8_result = replace(t8, {proc = {apple = "fruit", dog = "animal"}, mode ="replace"})
assertMessage(t8_result, {"fruit", "banana", "carrot", "animal", "elephant"})

-- Test 9: Replace with a string processor and custom arguments
local t9 = {"apple", "banana", "carrot", "dog", "elephant"}
local t9_result = replace(t9, {cond = "banana", mode = "replace", proc = {_f = "%s_ed"}, args = "v"})
assertMessage(t9_result, {"apple", "banana_ed", "carrot", "dog", "elephant"})

-- Test 11: Replace with a list processor
local t11 = {"apple", "banana", "carrot", "dog", "elephant"}
local t11_result = replace(
  t11, 
  {
    cond = "banana", 
    mode = "replace", 
    proc = {"fruit", "modified"}, 
  }
)
assertMessage(t11_result, {"apple", "fruit", "modified", "carrot", "dog", "elephant"})

-- Test 12: Replace using conditionProcSpecParallelList
local t12 = {"apple", "banana", "carrot", "dog", "elephant"}
local t12_result = replace(t12, {{"apple", "carrot"}, {"fruit", "vegetable"}}, {mode = "replace"})
assertMessage(t12_result, {"fruit", "banana", "vegetable", "dog", "elephant"})

-- Test 13: Replace with a condition using _invert
local t13 = {"apple", "banana", "carrot", "dog", "elephant"}
local t13_result = replace(t13, {cond = {_r = "a", _invert = true}, mode = "replace", proc = "no_a"})
assertMessage(t13_result, {"apple", "banana", "carrot", "no_a", "elephant"})

-- Test 14: Replace using globalopts
local t14 = {"apple", "banana", "carrot", "dog", "elephant"}
local t14_result = replace(t14, {{"apple", "carrot"}, {"fruit", "vegetable"}}, {mode = "replace"})
assertMessage(t14_result, {"fruit", "banana", "vegetable", "dog", "elephant"})

-- Test 15: Replace using conditionProcSpecPair
local t15 = {"apple", "banana", "carrot", "dog", "elephant"}
local t15_result = replace(t15, { {"apple", "fruit"}, {"carrot", "vegetable"}, {"dog", "animal"} }, {mode = "replace"})
assertMessage(t15_result, {"fruit", "banana", "vegetable", "animal", "elephant"})

-- Test 16: Replace with args set to 'k'
local ot16 = ovtable.init({
  {key = "apple", value = 1},
  {key = "banana", value = 2} 
})
local ot16_result = replace(
  ot16, 
  {
    cond = {_type = "number"}, 
    mode = "replace", 
    proc = rev, 
    args = "k",
    ret = "k"
  }
)
assertMessage(
  ot16_result, 
  ovtable.init({ 
    {key = "elppa", value = 1}, 
    {key = "ananab", value = 2} 
  })
)

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
assertMessage(ot19_result, ovtable.init({
    {key = "apple", value = "3"},
    {key = "banana", value = "3"}
}))

-- Test 20: Replace with a condition using _contains for orderedtables
local ot20 = ovtable.init({ {key = "apple", value = "fruit"}, {key = "banana", value = "fruit"}, {key = "carrot", value = "vegetable"} })
local ot20_result = replace(ot20, {cond = {_contains = "fruit"}, mode = "replace", proc = "tasty_fruit"})
assertMessage(ot20_result, ovtable.init({
    {k="apple", v="tasty_fruit"},
    {k="banana", v="tasty_fruit"},
    {k="carrot", v="vegetable"}
}))