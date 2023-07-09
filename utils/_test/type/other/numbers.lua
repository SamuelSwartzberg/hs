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
