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
  true
)

assertMessage(
  isNumber(-1.2, "float"),
  true
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
  intOfLength(3, "lower"),
  100
)

assertMessage(
  intOfLength(1, "lower"),
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
  intOfLength(2, "center"),
  50
)


local lower = 22
local upper = 179

local randnr1 = rand({low = lower, high = upper})

assertMessage(
  randnr1 >= lower,
  true
)

assertMessage(
  randnr1 <= upper,
  true
)

local randMustBeInt = rand({low = lower, high = upper})

assertMessage(
  isNumber(randMustBeInt, "int"),
  true
)

local randMustBeFloat = rand({low = 12.34, high = 12.34})


assertMessage(
  randMustBeFloat,
  12.34
)

local randMustBeInt2 = rand({low = 12.34, high = 12.34}, "int")

assertMessage(
  randMustBeInt2,
  12
)

assertMessage(
  toNumber(1.6, "int", "nil"),
  2
)

assertMessage(
  toNumber("1.6", "int", "nil"),
  2
)

assertMessage(
  pcall(toNumber, "wololo", "int", "You face JARAXXUS, EREDAR LORD OF THE BURNING LEGION!"),
  false
)

assertMessage(
  toNumber(1.6, "int", "nil"),
  2
)

assertMessage(
  toNumber("wolo6", "pos-int", "nil"),
  nil
)

assertMessage(
  toNumber("wolo6", "pos-int", "invalid-number"),
  -math.huge
)

assertMessage(
  pcall(toNumber, "wolo6", "You face JARAXXUS, EREDAR LORD OF THE BURNING LEGION!"),
  false
)