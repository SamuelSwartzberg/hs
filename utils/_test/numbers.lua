assertMessage(
  toInt(1.6, "nil"),
  2
)

assertMessage(
  toInt("1.6", "nil"),
  nil
)

assertMessage(
  toInt("1.6", "0"),
  0
)

assertMessage(
  pcall(toInt, "1.6", "You face JARAXXUS, EREDAR LORD OF THE BURNING LEGION!"),
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
  largestIntOfLength(4),
  9999
)

assertMessage(
  largestIntOfLength(1),
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

assertMessage(
  isGeneralBase64(rand({len = 50}, "b64")),
  true
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

assertValuesContainExactly(
  seq(1, 5),
  {1, 2, 3, 4, 5}
)

assertValuesContainExactly(
  seq(1, 5, 2),
  {1, 3, 5}
)