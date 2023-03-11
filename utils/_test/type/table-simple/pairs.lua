
local list_from_a_to_f = { "a", "b", "c", "d", "e", "f" }
local next_ipair = sipairs(list_from_a_to_f)

local k, v = next_ipair()
assertMessage(k, 1)
assertMessage(v, "a")

k, v = next_ipair()
assertMessage(k, 2)
assertMessage(v, "b")

k, v = next_ipair()
assertMessage(k, 3)
assertMessage(v, "c")

local next_ikey = sikeys(list_from_a_to_f)

assertMessage(next_ikey(), 1)
assertMessage(next_ikey(), 2)
assertMessage(next_ikey(), 3)

local next_ivalue = sivalues(list_from_a_to_f)

assertMessage(next_ivalue(), "a")
assertMessage(next_ivalue(), "b")
assertMessage(next_ivalue(), "c")

local foobar_table = ovtable.new()

foobar_table.bar = "42"
foobar_table.foo = "26"

local next_foobar = spairs(foobar_table)

k, v = next_foobar()
assertMessage(k, "bar")
assertMessage(v, "42")

k, v = next_foobar()
assertMessage(k, "foo")
assertMessage(v, "26")

local next_foobar_key = skeys(foobar_table)

assertMessage(next_foobar_key(), "bar")
assertMessage(next_foobar_key(), "foo")

local next_foobar_value = svalues(foobar_table)

assertMessage(next_foobar_value(), "42")
assertMessage(next_foobar_value(), "26")
