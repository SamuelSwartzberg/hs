assertMessage(
  concat({1, 2}, nil),
  {1, 2}
)

assertMessage(
  concat({1, 2}, false),
  {1, 2, false}
)

assertMessage(
  concat({1, 2}, { a  = 1}),
  {1, 2, { a = 1}}
)

assertMessage(
  concat({1, 2}, {3, 4}),
  {1, 2, 3, 4}
)

assertMessage(
  concat({1, 2}, {{3, 4}}),
  {1, 2, {3, 4}}
)

assertMessage(
  map({ 1, 2 , 3}, function(item) return false, {item, item + 1} end, {
    args = "k",
    ret = "kv",
    flatten = true
  }),
  {1, 2, 2, 3, 3, 4}
)

assertMessage(
  map({1,2,3}, function(x) return x end),
  {1,2,3}
)

assertMessage(
  toSet({1,1,1,2,3,3}),
  {1,2,3}
)

assertMessage(
  filter({1, "", 2, "", 3}, true),
  {1, 2, 3}
)

assertMessage(
  filter({1, " ", 2, " ", 3}, true),
  {1, " ", 2, " ", 3}
)

assertMessage(
  filter({1, 2, 3}, true),
  {1, 2, 3}
)
assertMessage(
  slice({1,2,3}, 1),
  {1,2,3}
)

assertMessage(
  slice({1,2,3}, 2),
  {2,3}
)

assertMessage(
  slice({1,2,3}, 4),
  {}
)

assertMessage(
  slice({1,2,3}, 1, 1),
  {1}
)

assertMessage(
  slice({1,2,3}, 1, 2),
  {1,2}
)

assertMessage(
  slice({1,2,3}, 1, 4),
  {1,2,3}
)

assertMessage(
  slice({1,2,3}, 2, 1),
  {}
)

assertMessage(
  slice({1,2,3}, 1, -1),
  {1,2,3}
)

assertMessage(
  slice({1,2,3}, 1, -2),
  {1,2}
)

assertMessage(
  slice({1,2,3}, 2, -1),
  {2,3}
)

assertMessage(
  slice({1,2,3}, nil, 3),
  {1,2,3}
)

assertMessage(
  slice({1,2,3}, 1, nil),
  {1,2,3}
)

assertMessage(
  slice({1,2,3}),
  {1,2,3}
)

assertMessage(
  slice({1,2,3}, 1, nil, 2),
  {1,3}
)

assertMessage(
  slice({1,2,3}, 2, nil, 2),
  {2}
)

assertMessage(
  slice({1,2,3}, 1, nil, 3),
  {1}
)

assertMessage(
  listSort(fixListWithNil({1, nil, 2, nil, 3})),
  {1, 2, 3}
)

assertMessage(
  listSort(fixListWithNil({1, 2, 3})),
  {1, 2, 3}
)

assertMessage(
  listSort(fixListWithNil({nil, 1, 2, nil})),
  {1, 2}
)

assertMessage(
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
  map(powerset({1, 2, 3}), function(x) return multiply(x, 2) end),
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

assertMessage(
  concat(
    {
      isopts = "isopts",
      sep = "|",
    },
    {1, 2},
    4,
    {5, 6}
  ),
  {1, 2, "|", 4, "|", 5, 6}
)