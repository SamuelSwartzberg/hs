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
