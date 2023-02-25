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
  toPosInt(1.6, "nil"),
  2
)

assertMessage(
  toPosInt("1.6", "nil"),
  nil
)

assertMessage(
  toPosInt("1.6", "-1"),
  -1
)

assertMessage(
  pcall(toPosInt, "1.6", "You face JARAXXUS, EREDAR LORD OF THE BURNING LEGION!"),
  false
)

assertMessage(
  isInt(1.6),
  false
)

assertMessage(
  isInt(1),
  true
)

assertMessage(
  isNegInt(-1.6),
  false
)

assertMessage(
  isNegInt(-1),
  true
)

assertMessage(
  isNegInt(1),
  false
)

assertMessage(
  isFloat(1.6),
  true
)

assertMessage(
  isFloat(1),
  false
)

assertMessage(
  isFloat(-1.2),
  true
)

assertMessage(
  smallestIntOfLength(3),
  100
)

assertMessage(
  smallestIntOfLength(1),
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
  lengthOfInt(randomInt(4)),
  4
)

assertMessage(
  lengthOfInt(randomInt(1)),
  1
)

assertMessage(
  isGeneralBase32(base64RandomString(50)),
  true
)

local lower = 22
local upper = 179

local rand = randBetween(lower, upper)

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