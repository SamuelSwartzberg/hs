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

