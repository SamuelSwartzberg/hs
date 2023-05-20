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

for k, v in prs(test_ovtable) do
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

for i, v in iprs(test_ovtable) do

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
  keys(test_ovtable),
  keys(test_nonov_assoc_arr)
)

assertMessage(
  values(test_ovtable),
  values(test_nonov_assoc_arr)
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
  values(test_ovtable),
  test_nonov_list_new
)

test_ovtable["IV"] = nil 

assertMessage(
  values(test_ovtable),
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

for k, v in revprs(ovtable) do
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

ovtable_manual["foo"] = returnAdd1
ovtable_manual["bar"] = returnEmptyString

assertMessage(
  ovtable.init({
    { "foo", returnAdd1 },
    { "bar", returnEmptyString }
  }),
  ovtable_manual
)

assertMessage(
  ovtable.init({
    { key = "foo", value = returnAdd1 },
    { key = "bar", value = returnEmptyString },
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