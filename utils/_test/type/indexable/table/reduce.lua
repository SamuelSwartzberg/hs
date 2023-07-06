assertMessage(
  reduce(
    { 2, 3, 4, 5},
    transf.number_a_and_b.sum
  ),
  14
)

assertMessage(
  reduce(
    { 2, 3, 4, 5},
    transf.number_a_and_b.sum,
    { init = 10 }
  ),
  24
)

assertMessage(
  reduce(
    { 2, 3, 4, 5},
    transf.number_a_and_b.sum,
    { last = true } -- last ^= reverse. B/c same options also used for find(), etc., and reverse would be confusing there.
  ),
  14
)

assertMessage(
  reduce(
    { 2, 3, 4, 5},
    transf.number_a_and_b.sum,
    { init = 10, last = true }
  ),
  24
)

assertMessage(
  reduce(
    { 2, 3, 4, 5},
    transf.number_a_and_b.sum,
    "k"
  ),
  10
)

assertMessage(
  reduce(
    { 2, 3, 4, 5},
    transf.number_a_and_b.sum,
    { init = 10, last = true, args = "k" }
  ),
  20
)

assertMessage(
  reduce(
    { 2, 3, 4, 5},
    transf.number_a_and_b.sum,
    { start = 2 }
  ),
  12
)

assertMessage(
  reduce(
    { 2, 3, 4, 5},
    transf.number_a_and_b.sum,
    { stop = 3 }
  ),
  9
)

assertMessage(
  reduce(
    { 2, 3, 4, 5},
    transf.number_a_and_b.sum,
    { start = 2, stop = 3 }
  ),
  7
)