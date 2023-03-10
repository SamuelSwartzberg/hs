
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