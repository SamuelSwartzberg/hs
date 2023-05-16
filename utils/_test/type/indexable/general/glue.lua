-- Test 1: Glue two strings
local str1 = "hello"
local str2 = "world"
local result1 = glue(str1, str2)
assertMessage(result1, "helloworld")

-- Test 2: Glue two lists
local list1 = {1, 2, 3}
local list2 = {4, 5, 6}
local result2 = glue(list1, list2)
assertMessage(result2, {1, 2, 3, 4, 5, 6})

-- Test 3: Glue a list and an orderedtable
local ot = ovtable.new()
ot["a"] = 1
ot["b"] = 2
ot["c"] = 3
local result3 = glue(list1, ot)
assertMessage(result3, {1, 2, 3, ot})

-- Test 4: Glue an orderedtable and a list (assume list is a pair)
local result4 = glue(ot, {"d", 4})
local expected4 = ovtable.new()
expected4["a"] = 1
expected4["b"] = 2
expected4["c"] = 3
expected4["d"] = 4
assertMessage(result4, expected4)

-- Test 5: Glue two orderedtables without recursion
local ot2 = ovtable.new()
ot2["d"] = 4
ot2["e"] = {5, 6}
local result5 = glue(ot, ot2, {recurse = false})
local expected5 = ovtable.new()
expected5["a"] = 1
expected5["b"] = 2
expected5["c"] = 3
expected5["d"] = 4
expected5["e"] = {5, 6}
assertMessage(result5, expected5)

-- Test 6: Glue two orderedtables with recursion
local ot3 = ovtable.new()
ot3["f"] = {7, 8}
local ot4 = ovtable.new()
ot4["g"] = 9
ot4["f"] = {10}
local result6 = glue(ot3, ot4)
local expected6 = ovtable.new()
expected6["f"] = {10}
expected6["g"] = 9
assertMessage(result6, expected6)

-- Test 7: Glue two orderedtables with recursion
local ot5 = ovtable.new()
ot5["h"] = {11, 12}
local ot6 = ovtable.new()
ot6["i"] = 13
ot6["h"] = {14}
local result7 = glue(ot5, ot6, {recurse = 1})
local expected7 = ovtable.new()
expected7["h"] = {14}
expected7["i"] = 13
assertMessage(result7, expected7)


-- Test 8: Glue two orderedtables with recursion enabled
local ot8a = ovtable.init({{k = "a", v = 1}, {k = "b", v = 2}, {k = "c", v = ovtable.new()}})
ot8a["c"] = ovtable.init({{k = "x", v = 3}, {k = "y", v = 4}})
local ot8b = ovtable.init({{k = "a", v = 5}, {k = "b", v = 6}, {k = "c", v = ovtable.new()}})
ot8b["c"] = ovtable.init({{k = "x", v = 7}, {k = "z", v = 8}})

local result8 = glue(ot8a, ot8b, {recurse = true})
local expected8 = ovtable.new()
expected8["a"] = 5
expected8["b"] = 6
expected8["c"] = ovtable.new()
expected8["c"]["x"] = 7
expected8["c"]["y"] = 4
expected8["c"]["z"] = 8
assertMessage(result8, expected8)

-- Test 9: Glue two orderedtables with recursion disabled
local result9 = glue(ot8a, ot8b, {recurse = false})
local expected9 = ovtable.new()
expected9["a"] = 5
expected9["b"] = 6
expected9["c"] = ot8b["c"]
assertMessage(result9, expected9)

-- Test 10: Glue two orderedtables without recursion and overwriting for first-level keys
local result10 = glue(ot8a, ot8b, {recurse = false, nooverwrite = true})
local expected10 = ovtable.new()
expected10["a"] = 1
expected10["b"] = 2
expected10["c"] = ot8a["c"]
assertMessage(result10, expected10)

-- exposes a bug where if both args were assoc arrs, and the second one had a key containing an assoc arr, an error would occur
assertMessage(
  glue({a="b"}, {c={}}),
  {a="b", c={}}
)

-- exposes an aggravated case of the above bug, where if both args were assoc arrs, and the first one had a key containing an assoc arr, for which key the second one had a list, it would try to treat that list as a pair to add, and misbehavior or an error would occur, depending if the list had 2 elements or not
assertMessage(
  glue({a={foo="bar"}}, {a={1}}),
  {a={1}}
)

-- exposes a bug where something something ovtable as nested value (unclear atm)

local nested_ovtable_glue_result = glue(
  {
    a = ovtable.init({
      {k = "b", v = 1},
    })
  },
  {
    a = {
      c = 2,
    }
  }
)

assertMessage(
  nested_ovtable_glue_result,
  {
    a = ovtable.init({
      {k = "b", v = 1},
      {k = "c", v = 2},
    })
  }
)

assertMessage(
  nested_ovtable_glue_result.a.isovtable,
  true
)

local nested_ovtable_glue_result_rev = glue(
  {
    a = {
      c = 2,
    }
  },
  {
    a = ovtable.init({
      {k = "b", v = 1},
    })
  }
)

assertMessage(
  nested_ovtable_glue_result_rev,
  {
    a = {
      c = 2,
      b = 1,
    }
  }
)

assertMessage(
  nested_ovtable_glue_result_rev.a.isovtable,
  nil
)

local glue_ovtable_to_nil = glue(
  {
    a = nil,
    b = "foo",
    c = {
      d = returnTrue
    }
  },
  {
    e = "bar",
    a = ovtable.init({
      {k = "f", v = 1},
      {k = "g", v = returnAdd1},
    }),
    c = {
      a = returnFalse
    }
  }
)

inspPrint(glue_ovtable_to_nil)


hsInspectCleaned(glue_ovtable_to_nil)

assertMessage(glue_ovtable_to_nil, glue_ovtable_to_nil)

error("stop")

ovtable.init({
  {k = "f", v = 1},
  {k = "g", v = returnAdd1},
})

assertMessage(
  glue_ovtable_to_nil,
  {
    a = ovtable.init({
      {k = "f", v = 1},
      {k = "g", v = returnAdd1},
    }),
    b = "foo",
    c = {
      a = returnFalse,
      d = returnTrue,
    },
    e = "bar",
  }
)

assertMessage(
  glue_ovtable_to_nil.a.isovtable,
  true
)

assertMessage(
  glue_ovtable_to_nil.a:len(),
  2
)