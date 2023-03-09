assertMessage(
  wdefarg(returnSame, 1)(2),
  2
)

assertValuesContainExactly(
  wdefarg(returnSame, 1)(),
  {1}
)

assertValuesContainExactly(
  wdefarg(returnSame, {2, 3})(),
  {2, 3}
)