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

for k, v in pairs(test_ovtable) do
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

for i, v in ipairs(test_ovtable) do
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

for k, v in test_ovtable:revpairs() do
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
