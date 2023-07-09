local test_ovtable = ovtable.init({
  { key = "I", value = "one" }, 
  { key = "II", value = "two"},
  { key = "III", value = "three"},
})

local test_nonov_assoc_arr = {
  I = "one",
  II = "two",
  III = "three",
}

local test_nonov_list = {
  "one",
  "two",
  "three",
}

local iters = 0

for k, v in get.indexable.key_value_stateless_iter(test_ovtable) do
  iters = iters + 1
  assertMessage(
    v == test_nonov_assoc_arr[k],
    true
  )
  local key_for_value = find(test_nonov_assoc_arr, v, {"v", "k"})
  assertMessage(
    k == key_for_value,
    true
  )
end

assertMessage(
  iters,
  3
)

local iters = 0

for i, v in get.indexable.index_value_stateless_iter(test_ovtable) do

  iters = iters + 1
  assertMessage(
    v == test_nonov_list[i],
    true
  )
  local index_for_value = find(test_nonov_list, v, {"v", "k"})
  assertMessage(
    i == index_for_value,
    true
  )
end

assertMessage(
  iters,
  3
)

local iters = 0

for k, v in test_ovtable:pairs() do
  iters = iters + 1
  assertMessage(
    v == test_nonov_assoc_arr[k],
    true
  )
  local key_for_value = find(test_nonov_assoc_arr, v, {"v", "k"})
  assertMessage(
    k == key_for_value,
    true
  )
end

assertMessage(
  iters,
  3
)

assertMessage(
  transf.native_table_or_nil.key_array(test_ovtable),
  transf.native_table_or_nil.key_array(test_nonov_assoc_arr)
)

assertMessage(
  transf.native_table_or_nil.value_array(test_ovtable),
  transf.native_table_or_nil.value_array(test_nonov_assoc_arr)
)

test_ovtable["IV"] = "four"

assertMessage(
  test_ovtable["IV"] == "four",
  true
)

local test_nonov_list_new = {
  "one",
  "two",
  "three",
  "four",
}

assertMessage(
  transf.native_table_or_nil.value_array(test_ovtable),
  test_nonov_list_new
)

test_ovtable["IV"] = nil 

assertMessage(
  transf.native_table_or_nil.value_array(test_ovtable),
  test_nonov_list
)

assertMessage(
  test_ovtable:keyindex("II"),
  2
)

assertMessage(
  test_ovtable:getindex(2),
  "two"
)

local reverse_test_ovtable = ovtable.init({
  { k = "III", v = "three" },
  { k = "II", v = "two" },
  { k = "I", v = "one" },
})

local indexer = 1

for k, v in get.indexable.reversed_key_value_stateless_iter(ovtable) do
  assertMessage(
    reverse_test_ovtable:keyindex(k),
    indexer
  )
  assertMessage(
    v,
    reverse_test_ovtable:getindex(indexer)
  )

  indexer = indexer + 1
end

assertMessage(
  reverse_test_ovtable:keyfromindex(1),
  "III"
)

assertMessage(
  reverse_test_ovtable:keyfromindex(2),
  "II"
)

assertMessage(
  reverse_test_ovtable:keyfromindex(3),
  "I"
)

-- test __index metamethod

assertMessage(
  reverse_test_ovtable[1],
  "three"
)

assertMessage(
  reverse_test_ovtable[2],
  "two"
)

assertMessage(
  reverse_test_ovtable[3],
  "one"
)

local ovtable_manual = ovtable.new()

ovtable_manual["foo"] = transf.number.with_1_added
ovtable_manual["bar"] = transf['nil'].empty_string

assertMessage(
  ovtable.init({
    { "foo", transf.number.with_1_added },
    { "bar", transf['nil'].empty_string }
  }),
  ovtable_manual
)

assertMessage(
  ovtable.init({
    { key = "foo", value = transf.number.with_1_added },
    { key = "bar", value = transf['nil'].empty_string },
  }),
  ovtable_manual
)


local succ, res = pcall(ovtable.init, {
  { "key", "value", "what's this? three elements? oh no!" }
})

assertMessage(succ, false)

local succ, res = pcall(ovtable.init, {
  { "key" }
})

assertMessage(succ, false)

local succ, res = pcall(ovtable.init, {
  { 
    key = "key",
    -- notice the lack of value
  }
})

assertMessage(succ, false)

local succ, res = pcall(ovtable.init, {
  { 
    -- notice the lack of key
    value = "value",
  }
})

assertMessage(succ, false)

local succ, res = pcall(ovtable.init, {
  { 
    -- notice the lack of k
    v = "value",
  }
})

assertMessage(succ, false)

local succ, res = pcall(ovtable.init,{
  {
    k = "key",
    -- notice the lack of v
  }
})

assertMessage(succ, false)