assertMessage(
  InfNo:get(true),
  "inf"
)

assertMessage(
  InfNo:get(false),
  "no"
)

assertMessage(
  InfNo:getBool("inf"),
  true
)

assertMessage(
  InfNo:getBool("no"),
  false
)

assertMessage(
  InfNo:getBool("nope"),
  nil
)

assertMessage(
  InfNo:invBool(true),
  "no"
)

assertMessage(
  InfNo:invBool(false),
  "inf"
)

assertMessage(
  InfNo:invV("inf"),
  "no"
)

assertMessage(
  InfNo:invV("no"),
  "inf"
)

assertMessage(
  InfNo:inv("inf"),
  "no"
)

assertMessage(
  InfNo:inv("no"),
  "inf"
)

assertMessage(
  InfNo:inv(true),
  "no"
)

assertMessage(
  InfNo:inv(false),
  "inf"
)