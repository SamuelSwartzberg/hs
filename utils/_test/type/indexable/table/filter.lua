
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