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
  transf.int.length(rand({len=4})),
  4
)

assertMessage(
  transf.int.length(rand({len=1})),
  1
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
