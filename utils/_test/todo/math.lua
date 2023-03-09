assertMessage(
  additionRingModuloN(1, 5, 4),
  2
)

assertMessage(
  additionRingModuloN(1, 5, 3),
  0
)

assertMessage(
  subtractionRingModuloN(1, 5, 4),
  0
)

assertMessage(
  isClose(1, 1.1, 0.2),
  true
)

assertMessage(
  isClose(1, 2, 0.1),
  false
)

assertMessage(
  crementIfNumber(1, "de"),
  0
)

assertMessage(
  crementIfNumber("1", "de"),
  "1"
)

assertMessage(
  isEven(2),
  true
)