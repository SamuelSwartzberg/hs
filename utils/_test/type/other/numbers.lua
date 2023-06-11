assertMessage(
  is.any.int(1.6),
  false
)

assertMessage(
  is.any.int(1),
  true
)

assertMessage(
  is.any.neg_int(-1.6),
  false
)

assertMessage(
  is.any.neg_int(-1),
  true
)

assertMessage(
  is.any.neg_int(1),
  false
)

assertMessage(
  is.any.float(1.6),
  true
)

assertMessage(
  is.any.float(1),
  true
)

assertMessage(
  is.any.float(-1.2),
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

assert(
  randnr1 >= lower
)

assert(
  randnr1 <= upper
)

local randMustBeInt = rand({low = lower, high = upper})

assert(
  is.number.int(randMustBeInt)
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