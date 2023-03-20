assertMessage(
  wdefarg(returnSame, 1)(2),
  2
)

assertMessage(
  wdefarg(returnSame, 1)(),
  {1}
)

assertMessage(
  wdefarg(returnSame, {2, 3})(),
  {2, 3}
)