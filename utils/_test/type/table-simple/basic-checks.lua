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
  is.any.empty_table({ a = 1 }),
  false
)

assertMessage(
  is.any.empty_table({ 1, 2, 3 }),
  false
)

assertMessage(
  is.any.empty_table({}),
  true
)

assertMessage(
  is.any.empty_table(array({})),
  true
)

assertMessage(
  is.any.empty_table(assoc({})),
  true
)

assertMessage(
  is.table.empty_unspecified_table({ a = 1 }),
  false
)

assertMessage(
  is.table.empty_unspecified_table({ 1, 2, 3 }),
  false
)

assertMessage(
  is.table.empty_unspecified_table({}),
  true
)

assertMessage(
  is.table.empty_unspecified_table(array({})),
  false
)

assertMessage(
  is.table.empty_unspecified_table(assoc({})),
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
  isListOrEmptyTable(array({})),
  true
)

assertMessage(
  isList(array({})),
  true
)

assertMessage(
  is.arraylike.hole_y_arraylike({ 1, 2, 3 }),
  false
)

assertMessage(
  is.arraylike.hole_y_arraylike({ 1, 2, nil, 3 }),
  true
)

assertMessage(
  is.arraylike.hole_y_arraylike({ 1, 2, nil, 3, nil }),
  true
)

assertMessage(
  get.any.has_key({ a = 1 }, "a"),
  true
)

assertMessage(
  get.any.has_key({ a = 1 }, "b"),
  false
)

assertMessage(
  get.any.has_key("not a table", "a"),
  false
)

assertMessage(
  get.array.contains({ 1, 2, 3 }, 1),
  true
)

assertMessage(
  get.array.contains({ 1, 2, 3 }, 4),
  false
)

assertMessage(
  get.array.contains("not a table", 1),
  false
)

assertMessage(
  get.array.contains({ 1, 2, 3 }, "1"),
  false
)

assertMessage(
  get.array.contains({ 1, 2, 3 }, nil),
  false
)

assertMessage(
  get.array.contains({ 1, {}, 3 }, {}),
  false
)