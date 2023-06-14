assertMessage(
  get.array.sorted(transf.hole_y_arraylike.array({1, nil, 2, nil, 3})),
  {1, 2, 3}
)

assertMessage(
  get.array.sorted(transf.hole_y_arraylike.array({1, 2, 3})),
  {1, 2, 3}
)

assertMessage(
  get.array.sorted(transf.hole_y_arraylike.array({nil, 1, 2, nil})),
  {1, 2}
)

assertMessage(
  transf.hole_y_arraylike.array({nil, { "ja" }, { "nein" }, nil}),
  {{ "ja" }, { "nein" }}
)
