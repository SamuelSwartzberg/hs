assertMessage(
  isListOrEmptyTable({ a = 1 }),
  false
)

assertMessage(
  isListOrEmptyTable({}),
  true
)

assertMessage(
  isEmptyTable({ a = 1 }),
  false
)

assertMessage(
  isEmptyTable({ 1, 2, 3 }),
  false
)

assertMessage(
  isEmptyTable({}),
  true
)

assertMessage(
  isListOrEmptyTable({ 1, 2, 3 }),
  true
)

assertMessage(
  isListOrEmptyTable(ovtable.new()),
  false
)

assertMessage(
  isListOrEmptyTable("not a table"),
  false
)

assertMessage(
  isListOrEmptyTable(assoc({})),
  false
)

assertMessage(
  isListOrEmptyTable(list({})),
  true
)

assertMessage(
  isSparseList({ 1, 2, 3 }),
  false
)

assertMessage(
  isSparseList({ 1, 2, nil, 3 }),
  true
)

assertMessage(
  isSparseList({ 1, 2, nil, 3, nil }),
  true
)

assertMessage(
  hasKey({ a = 1 }, "a"),
  true
)

assertMessage(
  hasKey({ a = 1 }, "b"),
  false
)

assertMessage(
  hasKey("not a table", "a"),
  false
)