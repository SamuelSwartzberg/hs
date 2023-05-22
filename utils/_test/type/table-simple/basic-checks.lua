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
  isEmptyTable(list({})),
  true
)

assertMessage(
  isEmptyTable(assoc({})),
  true
)

assertMessage(
  isUndeterminableTable({ a = 1 }),
  false
)

assertMessage(
  isUndeterminableTable({ 1, 2, 3 }),
  false
)

assertMessage(
  isUndeterminableTable({}),
  true
)

assertMessage(
  isUndeterminableTable(list({})),
  false
)

assertMessage(
  isUndeterminableTable(assoc({})),
  false
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

assertMessage(
  listContains({ 1, 2, 3 }, 1),
  true
)

assertMessage(
  listContains({ 1, 2, 3 }, 4),
  false
)

assertMessage(
  listContains("not a table", 1),
  false
)

assertMessage(
  listContains({ 1, 2, 3 }, "1"),
  false
)

assertMessage(
  listContains({ 1, 2, 3 }, nil),
  false
)

assertMessage(
  listContains({ 1, {}, 3 }, {}),
  false
)