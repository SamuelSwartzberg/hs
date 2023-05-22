
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

assertMessage(
  copy(simple_ovtable, false).isovtable,
  true
)

assertMessage(
  copy(simple_ovtable, true).isovtable,
  true
)

local minimal_ovtable = ovtable.init({
  {"a", 1},
})

local minimal_ovtable_copy = copy(minimal_ovtable)

assertMessage(
  minimal_ovtable,
  minimal_ovtable_copy
)

assertMessage(
  minimal_ovtable:len(),
  1
)

assertMessage(
  minimal_ovtable_copy:len(),
  1
)

local tbl_w_ovtable = {
  a = ovtable.init({
    {"b", 2}
  }),
}

local tbl_w_ovtable_copy = copy(tbl_w_ovtable)

assertMessage(
  tbl_w_ovtable,
  tbl_w_ovtable_copy
)

assertMessage(
  tbl_w_ovtable.a.isovtable,
  true
)

assertMessage(
  tbl_w_ovtable_copy.a.isovtable,
  true
)

assertMessage(
  tbl_w_ovtable.a:len(),
  1
)

assertMessage(
  tbl_w_ovtable_copy.a:len(),
  1
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

for k, v in fastpairs(simple_assoc_of_assocs) do
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

local table_will_self_ref = {}

table_will_self_ref.self = table_will_self_ref

local deep_copy_of_table_will_self_ref = copy(table_will_self_ref, true)

assertMessage(
  deep_copy_of_table_will_self_ref.self,
  deep_copy_of_table_will_self_ref
)

assertMessage(
  deep_copy_of_table_will_self_ref.self ==   table_will_self_ref.self,
  false
)

local mult_self_ref = {}

mult_self_ref.a = mult_self_ref
mult_self_ref.b = mult_self_ref

local deep_copy_of_mult_self_ref = copy(mult_self_ref, true)

assertMessage(
  deep_copy_of_mult_self_ref.a,
  deep_copy_of_mult_self_ref
)

assertMessage(
  deep_copy_of_mult_self_ref.b,
  deep_copy_of_mult_self_ref
)

assertMessage(
  deep_copy_of_mult_self_ref.a == mult_self_ref.a,
  false
)

assertMessage(
  deep_copy_of_mult_self_ref.b == mult_self_ref.b,
  false
)

local deep_self_ref = {}

deep_self_ref.a = {}
deep_self_ref.a.b = {}

deep_self_ref.a.b.c = deep_self_ref

local deep_copy_of_deep_self_ref = copy(deep_self_ref, true)

assertMessage(
  deep_copy_of_deep_self_ref.a.b.c,
  deep_copy_of_deep_self_ref
)

assertMessage(
  deep_copy_of_deep_self_ref.a.b.c == deep_self_ref.a.b.c,
  false
)

local deep_child_ref = {}

deep_child_ref.a = {}
deep_child_ref.a.b = {}
deep_child_ref.a.b.c = deep_child_ref.a

local deep_copy_of_deep_child_ref = copy(deep_child_ref, true)

assertMessage(
  deep_copy_of_deep_child_ref.a.b.c,
  deep_copy_of_deep_child_ref.a
)

assertMessage(
  deep_copy_of_deep_child_ref.a.b.c == deep_child_ref.a,
  false
)

assertMessage(
  copy({
    foo = "bar"
  }, true),
  {
    foo = "bar"
  }
)


assertMessage(
  copy({
    foo = "bar"
  }),
  {
    foo = "bar"
  }
)

-- mutation test

local mutation_test_tbl_1 = {
  foo = "bar"
}

local mutation_test_tbl_2 = copy(mutation_test_tbl_1, false)

mutation_test_tbl_1.foo = "changed"

assertMessage(
  mutation_test_tbl_1.foo,
  "changed"
)

assertMessage(
  mutation_test_tbl_2.foo,
  "bar"
)

local mutation_test_tbl_3 = {
  foo = "bar",
  deep = {
    pink = "floyd"
  }
}

local mutation_test_tbl_4 = copy(mutation_test_tbl_3, false)


mutation_test_tbl_3.deep.pink = "floyd changed"

assertMessage(
  mutation_test_tbl_3.deep.pink,
  "floyd changed"
)

assertMessage(
  mutation_test_tbl_4.deep.pink,
  "floyd changed"
)

local mutation_test_tbl_5 = {
  foo = "bar",
  deep = {
    pink = "floyd"
  }
}

local mutation_test_tbl_6 = copy(mutation_test_tbl_5, true)

mutation_test_tbl_5.deep.pink = "floyd changed"

assertMessage(
  mutation_test_tbl_5.deep.pink,
  "floyd changed"
)

assertMessage(
  mutation_test_tbl_6.deep.pink,
  "floyd"
)