assertMessage(
  reduce(
    { 2, 3, 4, 5},
    returnSum
  ),
  14
)

assertMessage(
  reduce(
    { 2, 3, 4, 5},
    returnSum,
    { init = 10 }
  ),
  24
)

assertMessage(
  reduce(
    { 2, 3, 4, 5},
    returnSum,
    { last = true } -- last ^= reverse. B/c same options also used for find(), etc., and reverse would be confusing there.
  ),
  14
)

assertMessage(
  reduce(
    { 2, 3, 4, 5},
    returnSum,
    { init = 10, last = true }
  ),
  24
)

assertMessage(
  reduce(
    { 2, 3, 4, 5},
    returnSum,
    "k"
  ),
  10
)

assertMessage(
  reduce(
    { 2, 3, 4, 5},
    returnSum,
    { init = 10, last = true, args = "k" }
  ),
  20
)

assertMessage(
  reduce(
    { 2, 3, 4, 5},
    returnSum,
    { start = 2 }
  ),
  12
)

assertMessage(
  reduce(
    { 2, 3, 4, 5},
    returnSum,
    { stop = 3 }
  ),
  9
)

assertMessage(
  reduce(
    { 2, 3, 4, 5},
    returnSum,
    { start = 2, stop = 3 }
  ),
  5
)