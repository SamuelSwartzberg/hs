
assertMessage(
  toSet({1,1,1,2,3,3}),
  {1,2,3}
)

assertMessage(
  combinations({1, 2, 3}, 2),
  {
    {2, 1},
    {3, 1},
    {3, 2}
  }
)

assertMessage(
  combinations({1, 2, 3}, 3),
  {
    {3, 2, 1}
  }
)

assertMessage(
  combinations({1, 2, 3}, 1),
  {
    {1},
    {2},
    {3},
  }
)

assertMessage(
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

assertMessage(
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