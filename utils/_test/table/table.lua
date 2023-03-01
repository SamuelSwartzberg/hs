

assertMessage(
  isListOrEmptyTable({ a = 1 }),
  false
)

assertMessage(
  valuesContain({"foo", "bar", "baz"}, "bar"),
  true
)

assertMessage(
  valuesContain({"foo", "bar", "baz"}, "qux"),
  false
)

assertMessage(
  valuesContain({ a = 1, b = 2, c = 3 }, 2),
  true
)

assertMessage(
  valuesContain({ a = 1, b = 2, c = 3 }, "b"),
  false
)

assertMessage(
  valueFindString({"foo", "bar", "baz"}, "bar"),
  "bar"
)

assertMessage(
  valueFindString({"foo", "bar", "baz"}, "qux"),
  nil
)

--- map list, map func returns primitive
assertTable(
  map({ 1, 2, 3 }, function(value) return value + 1 end),
  { 2, 3, 4 }
)

--- map assoc arr, map func returns primitive
assertTable(
  map({ a = 1, b = 2, c = 3 }, function(value) return value + 1 end),
  { a = 2, b = 3, c = 4 }
)

--- map list, map func returns table
assertTable(
  map({ 1, 2, 3 }, function(value) return { value + 1 } end),
  { { 2 }, { 3 }, { 4 } }
)

--- map assoc arr, map func returns table
assertTable(
  map({ a = 1, b = 2, c = 3 }, function(value) return { value + 1 } end),
  { a = { 2 }, b = { 3 }, c = { 4 } }
)

assertTable(
  listSort(collectLeaves(
    {
      a = 1,
      b = {
        c = 2,
        d = {
          e = 3,
          f = 4
        }
      }
    }
  )),
  { 1, 2, 3, 4 }
)

assertTable(
  listSort(collectLeaves(
    {
      1,
      2,
      {
        3,
        {
          4
        },
        5
      }
    }
  )),
  { 1, 2, 3, 4, 5 }
)

assertMessage(
  valueFind(
    { 1, 2, 3 },
    function(value) return value == 2 end
  ),
  2
)

assertMessage(
  valueFindKeyString(
    { a = 1, b = 2, c = 3 },
    2
  ),
  "b"
)

assertMessage(
  tbllength(chunk({ 
    a = 1,
    b = 2,
    c = 3,
    d = 4,
    e = 5,
    f = 6,
    g = 7,
  }, 3)[1]),
  3
)

assertMessage(
  tbllength(chunk({ 
    a = 1,
    b = 2,
    c = 3,
    d = 4,
    e = 5,
    f = 6,
    g = 7,
  }, 3)[2]),
  3
)

assertMessage(
  tbllength(chunk({ 
    a = 1,
    b = 2,
    c = 3,
    d = 4,
    e = 5,
    f = 6,
    g = 7,
  }, 3)[3]),
  1
)

assertMessage(
  tbllength(chunk({ 
    a = 1,
    b = 2,
    c = 3,
    d = 4,
    e = 5,
    f = 6,
    g = 7,
  }, 1)[3]),
  1
)

assertMessage(
  tbllength(chunk({ 
    a = 1,
    b = 2,
    c = 3,
    d = 4,
    e = 5,
    f = 6,
    g = 7,
  }, 7)[1]),
  7
)

assertMessage(
  tbllength(chunk({ 
    a = 1,
    b = 2,
    c = 3,
    d = 4,
    e = 5,
    f = 6,
    g = 7,
  }, 8)[1]),
  7
)

local list_from_a_to_f = { "a", "b", "c", "d", "e", "f" }
local next_a_to_f = sipairs(list_from_a_to_f)

local k, v = next_a_to_f()
assertMessage(k, 1)
assertMessage(v, "a")

k, v = next_a_to_f()
assertMessage(k, 2)
assertMessage(v, "b")

k, v = next_a_to_f()
assertMessage(k, 3)
assertMessage(v, "c")

local foobar_table = ovtable.new()

foobar_table.bar = "42"
foobar_table.foo = "26"

local next_foobar = spairs(foobar_table)

local k, v = next_foobar()
assertMessage(k, "bar")
assertMessage(v, "42")

k, v = next_foobar()
assertMessage(k, "foo")
assertMessage(v, "26")

local nextValue = sivalues(list_from_a_to_f)

assertMessage(nextValue(), "a")
assertMessage(nextValue(), "b")
assertMessage(nextValue(), "c")

local nextKey = skeys(foobar_table)

assertMessage(nextKey(), "bar")
assertMessage(nextKey(), "foo")

assertTable(
  mapValueToStrippedValue({
    a = " 1 ",
    b = "2",
    c = "ro aaa r   ",
    d = 3
  }),
  {
    a = "1",
    b = "2",
    c = "ro aaa r",
    d = 3
  }
)