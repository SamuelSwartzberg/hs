assertMessage(
  toNumber(1.6, "int", "nil"),
  2
)

assertMessage(
  toNumber("1.6", "int", "nil"),
  nil
)

assertMessage(
  pcall(toNumber, "1.6", "int", "You face JARAXXUS, EREDAR LORD OF THE BURNING LEGION!"),
  false
)

assertMessage(
  toNumber(1.6, "int", "nil"),
  2
)

assertMessage(
  toNumber("1.6", "pos-int", "nil"),
  nil
)

assertMessage(
  toNumber("1.6", "pos-int", "invalid-number"),
  -math.huge
)

assertMessage(
  pcall(toNumber, "1.6", "You face JARAXXUS, EREDAR LORD OF THE BURNING LEGION!"),
  false
)

assertMessage(
  isNumber(1.6, "int"),
  false
)

assertMessage(
  isNumber(1, "int"),
  true
)

assertMessage(
  isNumber(-1.6, "neg-int"),
  false
)

assertMessage(
  isNumber(-1, "neg-int"),
  true
)

assertMessage(
  isNumber(1, "neg-int"),
  false
)

assertMessage(
  isNumber(1.6, "float"),
  true
)

assertMessage(
  isNumber(1, "float"),
  false
)

assertMessage(
  isNumber(-1.2, "float"),
  true
)

assertMessage(
  intOfLength(3),
  100
)

assertMessage(
  intOfLength(1),
  1
)

assertMessage(
  intOfLength(4, "upper"),
  9999
)

assertMessage(
  intOfLength(1, "upper"),
  9
)

assertMessage(
  lengthOfInt(rand({len=4})),
  4
)

assertMessage(
  lengthOfInt(rand({len=1})),
  1
)

local lower = 22
local upper = 179

local rand = rand({low = lower, high = upper})

assertMessage(
  rand >= lower,
  true
)

assertMessage(
  rand <= upper,
  true
)

