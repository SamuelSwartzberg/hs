assertMessage(
  isListOrEmptyTable({ a = 1 }),
  false
)

assertMessage(
  isList({ a = 1 }),
  false
)

assertMessage(
  isListOrEmptyTable({}),
  true
)

assertMessage(
  isList({}),
  false
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
  isList({ 1, 2, 3 }),
  true
)

assertMessage(
  isListOrEmptyTable(ovtable.new()),
  false
)

assertMessage(
  isList(ovtable.new()),
  false
)

assertMessage(
  isListOrEmptyTable("not a table"),
  false
)

assertMessage(
  isList("not a table"),
  false
)

assertMessage(
  isListOrEmptyTable(assoc({})),
  false
)

assertMessage(
  isList(assoc({})),
  false
)

assertMessage(
  isListOrEmptyTable(list({})),
  true
)

assertMessage(
  isList(list({})),
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