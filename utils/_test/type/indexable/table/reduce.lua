assertMessage(
  reduce(
    { 2, 3, 4, 5},
    transf.two_numbers.sum
  ),
  14
)

assertMessage(
  reduce(
    { 2, 3, 4, 5},
    transf.two_numbers.sum,
    { init = 10 }
  ),
  24
)

assertMessage(
  reduce(
    { 2, 3, 4, 5},
    transf.two_numbers.sum,
    { last = true } -- last ^= reverse. B/c same options also used for find(), etc., and reverse would be confusing there.
  ),
  14
)

assertMessage(
  reduce(
    { 2, 3, 4, 5},
    transf.two_numbers.sum,
    { init = 10, last = true }
  ),
  24
)

assertMessage(
  reduce(
    { 2, 3, 4, 5},
    transf.two_numbers.sum,
    "k"
  ),
  10
)

assertMessage(
  reduce(
    { 2, 3, 4, 5},
    transf.two_numbers.sum,
    { init = 10, last = true, args = "k" }
  ),
  20
)

assertMessage(
  reduce(
    { 2, 3, 4, 5},
    transf.two_numbers.sum,
    { start = 2 }
  ),
  12
)

assertMessage(
  reduce(
    { 2, 3, 4, 5},
    transf.two_numbers.sum,
    { stop = 3 }
  ),
  9
)

assertMessage(
  reduce(
    { 2, 3, 4, 5},
    transf.two_numbers.sum,
    { start = 2, stop = 3 }
  ),
  7
)