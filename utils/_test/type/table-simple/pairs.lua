
local list_from_a_to_f = { "a", "b", "c", "d", "e", "f" }
local next_ipr = transf.indexable.index_value_stateful_iter(list_from_a_to_f)

local k, v = next_ipr()
assertMessage(k, 1)
assertMessage(v, "a")

k, v = next_ipr()
assertMessage(k, 2)
assertMessage(v, "b")

k, v = next_ipr()
assertMessage(k, 3)
assertMessage(v, "c")

local next_ipair = transf.array.index_value_stateful_iter(list_from_a_to_f)

k, v = next_ipair()

assertMessage(k, 1)
assertMessage(v, "a")

k, v = next_ipair()

assertMessage(k, 2)
assertMessage(v, "b")

k, v = next_ipair()
assertMessage(k, 3)
assertMessage(v, "c")

local next_ik = transf.indexable.index_stateful_iter(list_from_a_to_f)

assertMessage(next_ik(), 1)
assertMessage(next_ik(), 2)
assertMessage(next_ik(), 3)


local foobar_table = ovtable.new()

foobar_table.bar = "42"
foobar_table.foo = "26"

local next_foobar = transf.indexable.key_value_stateful_iter(foobar_table)

k, v = next_foobar()
assertMessage(k, "bar")
assertMessage(v, "42")

k, v = next_foobar()
assertMessage(k, "foo")
assertMessage(v, "26")

local next_foobar_key = transf.indexable.key_stateful_iter(foobar_table)

assertMessage(next_foobar_key(), "bar")
assertMessage(next_foobar_key(), "foo")

local next_foobar_value = transf.indexable.value_stateful_iter(foobar_table)

assertMessage(next_foobar_value(), "42")
assertMessage(next_foobar_value(), "26")