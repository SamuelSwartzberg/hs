
assertMessage(
  transf.array.set({1,1,1,2,3,3}),
  {1,2,3}
)

assertMessage(
  get.array.combination_array({1, 2, 3}, 2),
  {
    {2, 1},
    {3, 1},
    {3, 2}
  }
)

assertMessage(
  get.array.combination_array({1, 2, 3}, 3),
  {
    {3, 2, 1}
  }
)

assertMessage(
  get.array.combination_array({1, 2, 3}, 1),
  {
    {1},
    {2},
    {3},
  }
)

assertMessage(
  transf.array.permutation_array({1, 2, 3}),
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
  transf.array.powerset({1, 2, 3}),
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