assertTable(
  listConcat({1, 2}, nil),
  {1, 2}
)

assertTable(
  listConcat({1, 2}, false),
  {1, 2, false}
)

assertTable(
  listConcat({1, 2}, { a  = 1}),
  {1, 2, { a = 1}}
)

assertTable(
  listConcat({1, 2}, {3, 4}),
  {1, 2, 3, 4}
)

assertTable(
  listConcat({1, 2}, {{3, 4}}),
  {1, 2, {3, 4}}
)

assertTable(
  listFlatten({ { 1, 2 }, 3, {4, {5}} }, 1),
  {1, 2, 3, 4, {5}}
)

assertTable(
  listFlatten({ { 1, 2 }, 3, {4, {5}} }, 2),
  {1, 2, 3, 4, 5}
)

assertTable(
  listFlatten({ { 1, 2 }, 3, {4, {5}} }, 3),
  {1, 2, 3, 4, 5}
)

assertTable(
  listFlatten({ { 1, 2 }, 3, {4, {5}} }, 0),
  {{1, 2}, 3, {4, {5}}}
)

assertTable(
  listFlatten({{a = 1}, {b = 2}}, 1),
  {{a = 1}, {b = 2}}
)

assertTable(
  map({ 1, 2 , 3}, function(item) return false, {item, item + 1} end, {
    args = "k",
    useas = "kv",
    flatten = true
  }),
  {1, 2, 2, 3, 3, 4}
)

assertTable(
  map({1,2,3}, function(x) return x end),
  {1,2,3}
)

assertTable(
  toSet({1,1,1,2,3,3}),
  {1,2,3}
)

assertTable(
  filter({1, "", 2, "", 3}, true),
  {1, 2, 3}
)

assertTable(
  filter({1, " ", 2, " ", 3}, true),
  {1, " ", 2, " ", 3}
)

assertTable(
  filter({1, 2, 3}, true),
  {1, 2, 3}
)
assertTable(
  slice({1,2,3}, 1),
  {1,2,3}
)

assertTable(
  slice({1,2,3}, 2),
  {2,3}
)

assertTable(
  slice({1,2,3}, 4),
  {}
)

assertTable(
  slice({1,2,3}, 1, 1),
  {1}
)

assertTable(
  slice({1,2,3}, 1, 2),
  {1,2}
)

assertTable(
  slice({1,2,3}, 1, 4),
  {1,2,3}
)

assertTable(
  slice({1,2,3}, 2, 1),
  {}
)

assertTable(
  slice({1,2,3}, 1, -1),
  {1,2,3}
)

assertTable(
  slice({1,2,3}, 1, -2),
  {1,2}
)

assertTable(
  slice({1,2,3}, 2, -1),
  {2,3}
)

assertTable(
  slice({1,2,3}, nil, 3),
  {1,2,3}
)

assertTable(
  slice({1,2,3}, 1, nil),
  {1,2,3}
)

assertTable(
  slice({1,2,3}),
  {1,2,3}
)

assertTable(
  slice({1,2,3}, 1, nil, 2),
  {1,3}
)

assertTable(
  slice({1,2,3}, 2, nil, 2),
  {2}
)

assertTable(
  slice({1,2,3}, 1, nil, 3),
  {1}
)

assertTable(
  listSort(fixListWithNil({1, nil, 2, nil, 3})),
  {1, 2, 3}
)

assertTable(
  listSort(fixListWithNil({1, 2, 3})),
  {1, 2, 3}
)

assertTable(
  listSort(fixListWithNil({nil, 1, 2, nil})),
  {1, 2}
)

assertTable(
  fixListWithNil({nil, { "ja" }, { "nein" }, nil}),
  {{ "ja" }, { "nein" }}
)

assertValuesContainExactly(
  combinations({1, 2, 3}, 2),
  {
    {2, 1},
    {3, 1},
    {3, 2}
  }
)

assertValuesContainExactly(
  combinations({1, 2, 3}, 3),
  {
    {3, 2, 1}
  }
)

assertValuesContainExactly(
  combinations({1, 2, 3}, 1),
  {
    {1},
    {2},
    {3},
  }
)

assertValuesContainExactly(
  permutations({1, 2, 3}),
  {
    {1, 2, 3},
    {1, 3, 2},
    {2, 1, 3},
    {2, 3, 1},
    {3, 1, 2},
    {3, 2, 1},
  }
)

assertValuesContainExactly(
  powerset({1, 2, 3}),
  {
    {},
    {1},
    {2},
    {3},
    {2, 1},
    {3, 1},
    {3, 2},
    {3, 2, 1},
  }
)

assertValuesContainExactly(
  map(powerset({1, 2, 3}), function(x) return listMultiply(x, 2) end),
  {
    {},
    {1, 1},
    {2, 2},
    {3, 3},
    {2, 1, 2, 1},
    {3, 1, 3, 1},
    {3, 2, 3, 2},
    {3, 2, 1, 3, 2, 1},
  }
)

assertTable(
  listJoin(
    {
      {1, 2},
      4,
      {5, 6}
    },
    "|"
  ),
  {1, 2, "|", 4, "|", 5, 6}
)