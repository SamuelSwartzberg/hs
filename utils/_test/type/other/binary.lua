assertMessage(
  get.binary_specifier.string(tblmap.binary_specifier_name.binary_specifier.inf_no, true),
  "inf"
)

assertMessage(
  get.binary_specifier.string(tblmap.binary_specifier_name.binary_specifier.inf_no, false),
  "no"
)

assertMessage(
  get.binary_specifier.boolean(tblmap.binary_specifier_name.binary_specifier.inf_no, "inf"),
  true
)

assertMessage(
  get.binary_specifier.boolean(tblmap.binary_specifier_name.binary_specifier.inf_no, "no"),
  false
)

assertMessage(
  pcall(get.binary_specifier.boolean, tblmap.binary_specifier_name.binary_specifier.inf_no, "foo"),
  false
)

assertMessage(
  get.binary_specifier.inverted_string(tblmap.binary_specifier_name.binary_specifier.inf_no, true),
  "no"
)

assertMessage(
  get.binary_specifier.inverted_string(tblmap.binary_specifier_name.binary_specifier.inf_no, false),
  "inf"
)

assertMessage(
  get.binary_specifier.inverted(tblmap.binary_specifier_name.binary_specifier.inf_no, "inf"),
  "no"
)

assertMessage(
  get.binary_specifier.inverted(tblmap.binary_specifier_name.binary_specifier.inf_no, "no"),
  "inf"
)

assertMessage(
  get.binary_specifier.inverted(tblmap.binary_specifier_name.binary_specifier.inf_no, "inf"),
  "no"
)

assertMessage(
  get.binary_specifier.inverted(tblmap.binary_specifier_name.binary_specifier.inf_no, "no"),
  "inf"
)

assertMessage(
  get.binary_specifier.inverted(tblmap.binary_specifier_name.binary_specifier.inf_no, true),
  "no"
)

assertMessage(
  get.binary_specifier.inverted(tblmap.binary_specifier_name.binary_specifier.inf_no, false),
  "inf"
)
