assertMessage(
  listMedian({-27, 5, 1, 8, 9}),
  5
)

assertMessage(
  listMedian({-27, 5, 1, 8, 9, 22}),
  5
)

assertMessage(
  listMedian({-27, 5, 1, 8, 9, 22}, nil, "lower"),
  5
)

assertMessage(
  listMedian({-27, 5, 1, 8, 9, 22}, nil, "upper"),
  8
)

assertMessage(
  listMedian({-27, 5, 1, 8, 9, 22}, nil, "average"),
  6.5
)

assertMessage(
  listMedian({-27, 5, 1, 8, 9, 22}, nil, "both"),
  {5, 8}
)