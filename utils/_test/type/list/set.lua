
assertMessage(
  toSet({1,1,1,2,3,3}),
  {1,2,3}
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