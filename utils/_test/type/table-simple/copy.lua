
local simple_list = { 1, 2, 3, 4, 5 }

assertMessage(
  copy(simple_list),
  simple_list
)

assertMessage(
  copy(simple_list) == simple_list,
  false
)

assertMessage(
  copy(simple_list, true),
  simple_list
)

local simple_assoc = { a = 1, b = 2, c = 3, d = 4, e = 5 }

assertMessage(
  copy(simple_assoc, false),
  simple_assoc
)

assertMessage(
  copy(simple_assoc) == simple_assoc,
  false
)

assertMessage(
  copy(simple_assoc, true),
  simple_assoc
)

local simple_ovtable = ovtable.init({
  {"a", 1},
  {"b", 2},
  {"c", 3},
  {"d", 4},
  {"e", 5},
})

assertMessage(
  copy(simple_ovtable, false),
  simple_ovtable
)

assertMessage(
  copy(simple_ovtable) == simple_ovtable,
  false
)

assertMessage(
  copy(simple_ovtable, true),
  simple_ovtable
)

local simple_list_of_lists = { {1, 2, 3}, {4, 5, 6}, {7, 8, 9} }

local shallowcopy_list_of_lists = copy(simple_list_of_lists, false)

local deepcopy_list_of_lists = copy(simple_list_of_lists, true)

assertMessage(
  shallowcopy_list_of_lists,
  simple_list_of_lists
)

assertMessage(
  shallowcopy_list_of_lists == simple_list_of_lists,
  false
)

assertMessage(
  deepcopy_list_of_lists,
  simple_list_of_lists
)

for i, v in iprs(simple_list_of_lists) do
  assertMessage(
    shallowcopy_list_of_lists[i] == v,
    true
  )

  assertMessage(
    deepcopy_list_of_lists[i] == v,
    false
  )
end

local simple_assoc_of_assocs = { a = { i = 1, ii = 2, iii = 3 }, b = { i = 4, ii = 5, iii = 6 }, c = { i = 7, ii = 8, iii = 9 } }

local shallowcopy_assoc_of_assocs = copy(simple_assoc_of_assocs, false)
local deepcopy_assoc_of_assocs = copy(simple_assoc_of_assocs, true)

assertMessage(
  shallowcopy_assoc_of_assocs,
  simple_assoc_of_assocs
)

assertMessage(
  shallowcopy_assoc_of_assocs == simple_assoc_of_assocs,
  false
)

assertMessage(
  deepcopy_assoc_of_assocs,
  simple_assoc_of_assocs
)

for k, v in prs(simple_assoc_of_assocs) do
  assertMessage(
    shallowcopy_assoc_of_assocs[k] == v,
    true
  )

  assertMessage(
    deepcopy_assoc_of_assocs[k] == v,
    false
  )
end

local ovtable_of_mixed_ovtable_assoc_arrs = ovtable.init({
  {"a", 1},
  {"b", {
    i = "w",
    ii = "ww",
    iii = "www",
  }},
  {"c", ovtable.init({
    {"j", "x"},
    {"jj", "xx"},
    {"jjj", "xxx"},
  })}
})

local shallowcopy_ovtable_of_mixed_ovtable_assoc_arrs = copy(ovtable_of_mixed_ovtable_assoc_arrs, false)
local deepcopy_ovtable_of_mixed_ovtable_assoc_arrs = copy(ovtable_of_mixed_ovtable_assoc_arrs, true)

assertMessage(
  shallowcopy_ovtable_of_mixed_ovtable_assoc_arrs,
  ovtable_of_mixed_ovtable_assoc_arrs
)

assertMessage(
  shallowcopy_ovtable_of_mixed_ovtable_assoc_arrs == ovtable_of_mixed_ovtable_assoc_arrs,
  false
)

assertMessage(
  deepcopy_ovtable_of_mixed_ovtable_assoc_arrs,
  ovtable_of_mixed_ovtable_assoc_arrs
)

assertMessage(
  shallowcopy_ovtable_of_mixed_ovtable_assoc_arrs.a == ovtable_of_mixed_ovtable_assoc_arrs.a,
  true
)

assertMessage(
  deepcopy_ovtable_of_mixed_ovtable_assoc_arrs.a == ovtable_of_mixed_ovtable_assoc_arrs.a,
  true
)

assertMessage(
  shallowcopy_ovtable_of_mixed_ovtable_assoc_arrs.b == ovtable_of_mixed_ovtable_assoc_arrs.b,
  true
)

assertMessage(
  deepcopy_ovtable_of_mixed_ovtable_assoc_arrs.b == ovtable_of_mixed_ovtable_assoc_arrs.b,
  false
)

assertMessage(
  shallowcopy_ovtable_of_mixed_ovtable_assoc_arrs.c == ovtable_of_mixed_ovtable_assoc_arrs.c,
  true
)

assertMessage(
  deepcopy_ovtable_of_mixed_ovtable_assoc_arrs.c == ovtable_of_mixed_ovtable_assoc_arrs.c,
  false
)