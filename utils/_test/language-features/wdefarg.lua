assertMessage(
  wdefarg(transf.any.same, 1)(2),
  2
)

assertMessage(
  wdefarg(transf.any.same, 1)(),
  {1}
)

assertMessage(
  wdefarg(transf.any.same, {2, 3})(),
  {2, 3}
)