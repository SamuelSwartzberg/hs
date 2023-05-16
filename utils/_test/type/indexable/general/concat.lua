-- Test 1: Basic concat with two strings
local result1 = concat("Hello, ", "World!")
assertMessage(result1, "Hello, World!")

-- Test 2: Basic concat with a list of strings
local result2 = concat({"Hello, ", "World!", " How are you?"})
assertMessage(result2, "Hello, World! How are you?")

-- Test 3: Basic concat with varargs of strings
local result3 = concat("Hello, ", "World!", " How are you?")
assertMessage(result3, "Hello, World! How are you?")

-- Test 4: Basic concat with a list of lists
local result4 = concat({{1, 2}, {3, 4}})
assertMessage(result4, {1, 2, 3, 4})

-- Test 5: Basic concat with varargs of lists
local result5 = concat({1, 2}, {3, 4})
assertMessage(result5, {1, 2, 3, 4})

-- Test 6: Concat with separator provided
local result6 = concat({sep = ", ", isopts = "isopts"}, "Hello", "World", "Lua")
assertMessage(result6, "Hello, World, Lua")

-- Test 7: Concat with list of separators provided
local result7 = concat({sep = {", ", "; ", " - "},  isopts = "isopts"}, "Hello", "World", "Lua")
assertMessage(result7, "Hello, World; Lua - ")

-- Test 8: Concat with associative arrays
local result8 = concat({a = 1, b = 2}, {c = 3, d = 4})
assertMessage(result8, {a = 1, b = 2, c = 3, d = 4})

-- Test 9: Concat with list and associative array
local result9 = concat({1, 2}, {a = 3, b = 4})
assertMessage(result9, {1, 2, {a = 3, b = 4}})

-- Test 10: Concat with 3 lists

local result10 = concat({1, 2}, {3, 4}, {5, 6})
assertMessage(result10, {1, 2, 3, 4, 5, 6})

-- Test 11: Concat with 3 associative arrays

local result11 = concat({a = 1, b = 2}, {c = 3, d = 4}, {e = 5, f = 6})
assertMessage(result11, {a = 1, b = 2, c = 3, d = 4, e = 5, f = 6})

-- Test 12: Concat with 3 associative arrays, where some keys are shared

local result12 = concat({a = 1, b = 2}, {b = 3, c = 4}, {c = 5, d = 6})
assertMessage(result12, {a = 1, b = 3, c = 5, d = 6})

-- Test 13: Concat with 3 associative arrays and separator

local result13 = concat(
  {
    sep = {
      { "i", "-"},
      { "ii", "-"},
      { "iii", "-"},
    },
    isopts = "isopts"
  },
  {a = 1, b = 2},
  {c = 3, d = 4},
  {e = 5, f = 6}
)

assertMessage(result13, {a = 1, b = 2, i = "-", c = 3, d = 4, ii = "-", e = 5, f = 6, iii = "-"})

assertMessage(
  concat(list({}), {a = 1, b = 2}, {c = 3, d = 4}, {e = 5, f = 6}),
  { {a = 1, b = 2}, {c = 3, d = 4}, {e = 5, f = 6} }
)

assertMessage(
  concat(assoc({}), {a = 1, b = 2}, {c = 3, d = 4}, {e = 5, f = 6}),
  {a = 1, b = 2, c = 3, d = 4, e = 5, f = 6}
)

assertMessage(
  concat({1, 2}, {a = 1, b = 2}, {c = 3, d = 4}, {e = 5, f = 6}),
  {1, 2, {a = 1, b = 2}, {c = 3, d = 4}, {e = 5, f = 6}}
)


-- some tests that were written for glue but which concat must also pass

local concat_ovtable_glue_result = concat(
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
  concat_ovtable_glue_result,
  {
    a = ovtable.init({
      {k = "b", v = 1},
      {k = "c", v = 2},
    })
  }
)

assertMessage(
  concat_ovtable_glue_result.a.isovtable,
  true
)

local concat_ovtable_glue_result_rev = concat(
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
  concat_ovtable_glue_result_rev,
  {
    a = {
      c = 2,
      b = 1,
    }
  }
)

assertMessage(
  concat_ovtable_glue_result_rev.a.isovtable,
  nil
)

local concat_ovtable_to_nil = concat(
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

assertMessage(
  concat_ovtable_to_nil,
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
  concat_ovtable_to_nil.a.isovtable,
  true
)

assertMessage(
  concat_ovtable_to_nil.a:len(),
  2
)