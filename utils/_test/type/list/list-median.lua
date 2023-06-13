assertMessage(
  get.array.median({-27, 5, 1, 8, 9}),
  5
)

assertMessage(
  get.array.median({-27, 5, 1, 8, 9, 22}),
  5
)

assertMessage(
  get.array.median({-27, 5, 1, 8, 9, 22}, nil, "lower"),
  5
)

assertMessage(
  get.array.median({-27, 5, 1, 8, 9, 22}, nil, "higher"),
  8
)

assertMessage(
  get.array.median({-27, 5, 1, 8, 9, 22}, nil, "average"),
  6.5
)

assertMessage(
  get.array.median({-27, 5, 1, 8, 9, 22}, nil, "both"),
  {5, 8}
)