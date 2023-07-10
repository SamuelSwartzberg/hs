-- Test data
local tbl = {10, 20, 30, 40, 50}
local emptyTbl = {}

-- Test iprs
-- Test default
local manual_counter = 0
for i, v in get.indexable.index_value_stateless_iter(tbl) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(i, 1)
    assertMessage(v, 10)
  elseif manual_counter == 2 then
    assertMessage(i, 2)
    assertMessage(v, 20)
  elseif manual_counter == 3 then
    assertMessage(i, 3)
    assertMessage(v, 30)
  elseif manual_counter == 4 then
    assertMessage(i, 4)
    assertMessage(v, 40)
  elseif manual_counter == 5 then
    assertMessage(i, 5)
    assertMessage(v, 50)
  elseif manual_counter == 6 then
    error("Should not iterate")
  end
end
assertMessage(
  manual_counter,
  5
)

-- Test empty table
for i, v in get.indexable.index_value_stateless_iter(emptyTbl) do
  error("Should not iterate")
end

-- Test start and stop
local manual_counter = 0
for i, v in get.indexable.index_value_stateless_iter(tbl, 2, 4) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(i, 2)
    assertMessage(v, 20)
  elseif manual_counter == 2 then
    assertMessage(i, 3)
    assertMessage(v, 30)
  elseif manual_counter == 3 then
    assertMessage(i, 4)
    assertMessage(v, 40)
  elseif manual_counter == 4 then
    error("Should not iterate")
  end
end

assertMessage(
  manual_counter,
  3
)

-- Test step

local manual_counter = 0
for i, v in get.indexable.index_value_stateless_iter(tbl, 1, 5, 2) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(i, 1)
    assertMessage(v, 10)
  elseif manual_counter == 2 then
    assertMessage(i, 3)
    assertMessage(v, 30)
  elseif manual_counter == 3 then
    assertMessage(i, 5)
    assertMessage(v, 50)
  elseif manual_counter == 4 then
    error("Should not iterate")
  end
end

assertMessage(
  manual_counter,
  3
)

-- Test negative step

local manual_counter = 0
for i, v in get.indexable.index_value_stateless_iter(tbl, 5, 1, -2) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(i, 5)
    assertMessage(v, 50)
  elseif manual_counter == 2 then
    assertMessage(i, 3)
    assertMessage(v, 30)
  elseif manual_counter == 3 then
    assertMessage(i, 1)
    assertMessage(v, 10)
  elseif manual_counter == 4 then
    error("Should not iterate")
  end
end

assertMessage(
  manual_counter,
  3
)

-- Test iprs on assoc arr (use key string equivalent order)

local assocArr = {a = 10, b = 20, c = 30, d = 40, e = 50}

local manual_counter = 0
for i, v in get.indexable.index_value_stateless_iter(assocArr) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(i, 1)
    assertMessage(v, 10)
  elseif manual_counter == 2 then
    assertMessage(i, 2)
    assertMessage(v, 20)
  elseif manual_counter == 3 then
    assertMessage(i, 3)
    assertMessage(v, 30)
  elseif manual_counter == 4 then
    assertMessage(i, 4)
    assertMessage(v, 40)
  elseif manual_counter == 5 then
    assertMessage(i, 5)
    assertMessage(v, 50)
  elseif manual_counter == 6 then
    error("Should not iterate")
  end
end

assertMessage(
  manual_counter,
  5
)

-- Test iprs on assoc arr with start, stop, and negative step

local manual_counter = 0

for i, v in get.indexable.index_value_stateless_iter(assocArr, 1, 3, -2) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(i, 3)
    assertMessage(v, 30)
  elseif manual_counter == 2 then
    assertMessage(i, 1)
    assertMessage(v, 10)
  elseif manual_counter == 3 then
    error("Should not iterate")
  end
end

assertMessage(
  manual_counter,
  2
)

-- Test iprs on ovtable (uses insertion order)

local test_ovtable = ovtable.init({
  {k = "e", v = 10},
  {k = "d", v = 20},
  {k = "c", v = 30},
  {k = "b", v = 40},
  {k = "a", v = 50},
})

local manual_counter = 0
for i, v in get.indexable.index_value_stateless_iter(test_ovtable) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(i, 1)
    assertMessage(v, 10)
  elseif manual_counter == 2 then
    assertMessage(i, 2)
    assertMessage(v, 20)
  elseif manual_counter == 3 then
    assertMessage(i, 3)
    assertMessage(v, 30)
  elseif manual_counter == 4 then
    assertMessage(i, 4)
    assertMessage(v, 40)
  elseif manual_counter == 5 then
    assertMessage(i, 5)
    assertMessage(v, 50)
  elseif manual_counter == 6 then
    error("Should not iterate")
  end
end

assertMessage(
  manual_counter,
  5
)

-- Test iprs on ovtable with start, stop, and negative step

local manual_counter = 0
for i, v in get.indexable.index_value_stateless_iter(test_ovtable, 1, 3, -2) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(i, 3)
    assertMessage(v, 30)
  elseif manual_counter == 2 then
    assertMessage(i, 1)
    assertMessage(v, 10)
  elseif manual_counter == 3 then
    error("Should not iterate")
  end
end

assertMessage(
  manual_counter,
  2
)

-- test that reviprs is equivalent to iprs with negative step

local manual_counter = 0
for i, v in reviprs(tbl) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(i, 5)
    assertMessage(v, 50)
  elseif manual_counter == 2 then
    assertMessage(i, 4)
    assertMessage(v, 40)
  elseif manual_counter == 3 then
    assertMessage(i, 3)
    assertMessage(v, 30)
  elseif manual_counter == 4 then
    assertMessage(i, 2)
    assertMessage(v, 20)
  elseif manual_counter == 5 then
    assertMessage(i, 1)
    assertMessage(v, 10)
  elseif manual_counter == 6 then
    error("Should not iterate")
  end
end

assertMessage(
  manual_counter,
  5
)

-- test pairs
-- test default on list

local manual_counter = 0
for k, v in get.indexable.key_value_stateless_iter(tbl) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(k, 1)
    assertMessage(v, 10)
  elseif manual_counter == 2 then
    assertMessage(k, 2)
    assertMessage(v, 20)
  elseif manual_counter == 3 then
    assertMessage(k, 3)
    assertMessage(v, 30)
  elseif manual_counter == 4 then
    assertMessage(k, 4)
    assertMessage(v, 40)
  elseif manual_counter == 5 then
    assertMessage(k, 5)
    assertMessage(v, 50)
  elseif manual_counter == 6 then
    error("Should not iterate")
  end
end

assertMessage(
  manual_counter,
  5
)

-- test default on assoc arr

local manual_counter = 0
for k, v in get.indexable.key_value_stateless_iter(assocArr) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(k, "a")
    assertMessage(v, 10)
  elseif manual_counter == 2 then
    assertMessage(k, "b")
    assertMessage(v, 20)
  elseif manual_counter == 3 then
    assertMessage(k, "c")
    assertMessage(v, 30)
  elseif manual_counter == 4 then
    assertMessage(k, "d")
    assertMessage(v, 40)
  elseif manual_counter == 5 then
    assertMessage(k, "e")
    assertMessage(v, 50)
  elseif manual_counter == 6 then
    error("Should not iterate")
  end
end

assertMessage(
  manual_counter,
  5
)

-- test default on ovtable

local manual_counter = 0
for k, v in get.indexable.key_value_stateless_iter(test_ovtable) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(k, "e")
    assertMessage(v, 10)
  elseif manual_counter == 2 then
    assertMessage(k, "d")
    assertMessage(v, 20)
  elseif manual_counter == 3 then
    assertMessage(k, "c")
    assertMessage(v, 30)
  elseif manual_counter == 4 then
    assertMessage(k, "b")
    assertMessage(v, 40)
  elseif manual_counter == 5 then
    assertMessage(k, "a")
    assertMessage(v, 50)
  elseif manual_counter == 6 then
    error("Should not iterate")
  end
end

assertMessage(
  manual_counter,
  5
)

-- test pairs with start, stop, and negative step on assoc arr

local manual_counter = 0
for k, v in get.indexable.key_value_stateless_iter(assocArr, 1, 3, -2) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(k, "c")
    assertMessage(v, 30)
  elseif manual_counter == 2 then
    assertMessage(k, "a")
    assertMessage(v, 10)
  elseif manual_counter == 3 then
    error("Should not iterate")
  end
end

assertMessage(
  manual_counter,
  2
)

local manual_counter = 0
for k, v in get.indexable.key_value_stateless_iter(assocArr, 1, -3) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(k, "a")
    assertMessage(v, 10)
  elseif manual_counter == 2 then
    assertMessage(k, "b")
    assertMessage(v, 20)
  elseif manual_counter == 3 then
    assertMessage(k, "c")
    assertMessage(v, 30)
  elseif manual_counter == 4 then
    error("Should not iterate")
  end
end

assertMessage(
  manual_counter,
  3
)

-- test pairs with negative step on ovtable

local manual_counter = 0
for k, v in get.indexable.key_value_stateless_iter(test_ovtable, 1, 5, -2) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(k, "a")
    assertMessage(v, 50)
  elseif manual_counter == 2 then
    assertMessage(k, "c")
    assertMessage(v, 30)
  elseif manual_counter == 3 then
    assertMessage(k, "e")
    assertMessage(v, 10)
  elseif manual_counter == 4 then
    error("Should not iterate")
  end
end

assertMessage(
  manual_counter,
  3
)

local manual_counter = 0
for k, v in get.indexable.key_value_stateless_iter(test_ovtable, 1, 5, -1) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(k, "a")
    assertMessage(v, 50)
  elseif manual_counter == 2 then
    assertMessage(k, "b")
    assertMessage(v, 40)
  elseif manual_counter == 3 then
    assertMessage(k, "c")
    assertMessage(v, 30)
  elseif manual_counter == 4 then
    assertMessage(k, "d")
    assertMessage(v, 20)
  elseif manual_counter == 5 then
    assertMessage(k, "e")
    assertMessage(v, 10)
  elseif manual_counter == 6 then
    error("Should not iterate")
  end
end

assertMessage(
  manual_counter,
  5
)

local manual_counter = 0
for k, v in get.indexable.key_value_stateless_iter(test_ovtable, 1, -1, -1) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(k, "a")
    assertMessage(v, 50)
  elseif manual_counter == 2 then
    assertMessage(k, "b")
    assertMessage(v, 40)
  elseif manual_counter == 3 then
    assertMessage(k, "c")
    assertMessage(v, 30)
  elseif manual_counter == 4 then
    assertMessage(k, "d")
    assertMessage(v, 20)
  elseif manual_counter == 5 then
    assertMessage(k, "e")
    assertMessage(v, 10)
  elseif manual_counter == 6 then
    error("Should not iterate")
  end
end

assertMessage(
  manual_counter,
  5
)

-- test that revpairs with positive step is equivalent to pairs with negative step

local manual_counter = 0
for k, v in get.indexable.reversed_key_value_stateless_iter(test_ovtable, 1, 5, 2) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(k, "a")
    assertMessage(v, 50)
  elseif manual_counter == 2 then
    assertMessage(k, "c")
    assertMessage(v, 30)
  elseif manual_counter == 3 then
    assertMessage(k, "e")
    assertMessage(v, 10)
  elseif manual_counter == 4 then
    error("Should not iterate")
  end
end

assertMessage(
  manual_counter,
  3
)

-- test that limit works 
local manual_counter = 0
for  k, v in get.indexable.reversed_key_value_stateless_iter(test_ovtable, 1, 5, 2, 2) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(k, "a")
    assertMessage(v, 50)
  elseif manual_counter == 2 then
    assertMessage(k, "c")
    assertMessage(v, 30)
  elseif manual_counter == 3 then
    error("Should not iterate")
  end
end

assertMessage(
  manual_counter,
  2
)

-- test iprs on mixed table

local mixed_table = { 1, 2, 3, a = 4, b = 5, c = 6 }
local manual_counter = 0

for k, v in get.indexable.index_value_stateless_iter(mixed_table) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(k, 1)
    assertMessage(v, 1)
  elseif manual_counter == 2 then
    assertMessage(k, 2)
    assertMessage(v, 2)
  elseif manual_counter == 3 then
    assertMessage(k, 3)
    assertMessage(v, 3)
  elseif manual_counter == 4 then
    assertMessage(k, 4)
    assertMessage(v, 4)
  elseif manual_counter == 5 then
    assertMessage(k, 5)
    assertMessage(v, 5)
  elseif manual_counter == 6 then
    assertMessage(k, 6)
    assertMessage(v, 6)
  elseif manual_counter == 7 then
    error("Should not iterate")
  end
end

assertMessage(
  manual_counter,
  6
)

-- test prs on mixed table

local manual_counter = 0

for k, v in get.indexable.key_value_stateless_iter(mixed_table) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(k, 1)
    assertMessage(v, 1)
  elseif manual_counter == 2 then
    assertMessage(k, 2)
    assertMessage(v, 2)
  elseif manual_counter == 3 then
    assertMessage(k, 3)
    assertMessage(v, 3)
  elseif manual_counter == 4 then
    assertMessage(k, "a")
    assertMessage(v, 4)
  elseif manual_counter == 5 then
    assertMessage(k, "b")
    assertMessage(v, 5)
  elseif manual_counter == 6 then
    assertMessage(k, "c")
    assertMessage(v, 6)
  elseif manual_counter == 7 then
    error("Should not iterate")
  end
end

assertMessage(
  manual_counter,
  6
)

local ovtable_w_pairs = ovtable.init({
  { "a", "1"},
  { "b", "1"},
  { "c", "1"},
})

local manual_counter = 0

for k, v in get.indexable.key_value_stateless_iter(ovtable_w_pairs) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(k, "a")
    assertMessage(v, "1")
  elseif manual_counter == 2 then
    assertMessage(k, "b")
    assertMessage(v, "1")
  elseif manual_counter == 3 then
    assertMessage(k, "c")
    assertMessage(v, "1")
  elseif manual_counter == 4 then
    error("Should not iterate")
  end
end

assertMessage(
  manual_counter,
  3
)

local ovtable_w_function_values = ovtable.init({
  { key = "a", value = function() return 1 end },
  { key = "b", value = function() return 2 end },
  { key = "c", value = function() return 3 end },
})

local manual_counter = 0
for k, v in get.indexable.key_value_stateless_iter(ovtable_w_function_values) do 
  local val = v()
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(k, "a")
    assertMessage(val, 1)
  elseif manual_counter == 2 then
    assertMessage(k, "b")
    assertMessage(val, 2)
  elseif manual_counter == 3 then
    assertMessage(k, "c")
    assertMessage(val, 3)
  elseif manual_counter == 4 then
    error("Should not iterate")
  end
end

assertMessage(
  manual_counter,
  3
)

-- test get.stateless_iter_component_array.table


assertMessage(
  get.stateless_iter_component_array.table(transf.stateless_iter.stateless_iter_component_array(string.gmatch("abc", ".")), {tolist=true, ret="v"}),
  { "a", "b", "c" }
)

assertMessage(
  get.stateless_iter_component_array.table(transf.stateless_iter.stateless_iter_component_array(string.gmatch("abc", "d")),{tolist=true, ret="v"}),
  {}
)

assertMessage(
  get.stateless_iter_component_array.table(transf.stateless_iter.stateless_iter_component_array(get.indexable.index_value_stateless_iter({"a", "b", "c"})), {noovtable=true}),
  { "a", "b", "c" }
)

assertMessage(
  get.stateless_iter_component_array.table(transf.stateless_iter.stateless_iter_component_array(get.indexable.key_value_stateless_iter({a = "a", b = "b", c = "c"}))).isarr,
  nil
)

assertMessage(
  get.stateless_iter_component_array.table(transf.stateless_iter.stateless_iter_component_array(get.indexable.key_value_stateless_iter({"a", "b", "c"}))).isassoc,
  nil
)

assertMessage(
  get.stateless_iter_component_array.table(transf.stateless_iter.stateless_iter_component_array(get.indexable.key_value_stateless_iter({a = "a", b = "b", c = "c"}))),
  { a = "a", b = "b", c = "c" }
)

-- test fastpairs, a pairs dropin that also works on ovtables

local tbl_w_var_values = {
  a = true,
  b = transf['nil']['nil'],
  c = 1,
  d = "string",
}

local manual_counter = 0

for k, v in transf.table.pair_stateless_iter(tbl_w_var_values) do
  manual_counter = manual_counter + 1
  -- fastpairs does not guarantee order
  if manual_counter == 5 then
    error("Should not iterate")
  end
end

assertMessage(
  manual_counter,
  4
)

local ovtable_w_var_values = ovtable.init({
  { key = "a", value = true },
  { key = "b", value = transf['nil']['nil'] },
  { key = "c", value = 1 },
  { key = "d", value = "string" },
})

local manual_counter = 0

for k, v in transf.table.pair_stateless_iter(ovtable_w_var_values) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(k, "a")
    assertMessage(v, true)
  elseif manual_counter == 2 then
    assertMessage(k, "b")
    assertMessage(v, transf['nil']['nil'])
  elseif manual_counter == 3 then
    assertMessage(k, "c")
    assertMessage(v, 1)
  elseif manual_counter == 4 then
    assertMessage(k, "d")
    assertMessage(v, "string")
  elseif manual_counter == 5 then
    error("Should not iterate")
  end
end

assertMessage(
  manual_counter,
  4
)

local list_w_var_values = {
  true,
  transf['nil']['nil'],
  1,
  "string",
}


local manual_counter = 0

for k, v in transf.table.pair_stateless_iter(list_w_var_values) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(k, 1)
    assertMessage(v, true)
  elseif manual_counter == 2 then
    assertMessage(k, 2)
    assertMessage(v, transf['nil']['nil'])
  elseif manual_counter == 3 then
    assertMessage(k, 3)
    assertMessage(v, 1)
  elseif manual_counter == 4 then
    assertMessage(k, 4)
    assertMessage(v, "string")
  elseif manual_counter == 5 then
    error("Should not iterate")
  end
end