assertMessage(
  returnTrue(),
  true
)

assertMessage(
  returnFalse(),
  false
)

assertMessage(
  returnNot(true),
  false
)

assertMessage(
  returnBool("foo"),
  true
)

assertMessage(
  returnBool(nil),
  false
)

assertMessage(
  returnNil(),
  nil
)

assertMessage(
  returnEmptyString(),
  ""
)


assertMessage(
  returnEmptyTable(),
  {}
)

assertMessage(
  returnZero(),
  0
)

assertMessage(
  returnOne(),
  1
)

assertMessage(
  returnSame(1),
  1
)

assertMessage(
  returnSame("foo"),
  "foo"
)

assertMessage(
  select(2, returnAny(1, 2, 3)),
  2
)

assertMessage(
  select(4, returnSameNTimes("foo", 5)),
  "foo"
)

assertMessage(
  select(6, returnSameNTimes("foo", 5)),
  nil
)

assertMessage(
  returnNumArgs(1, 2, 3),
  3
)

assertMessage(
  is.a_and_b.equal(1, 1),
  true
)

assertMessage(
  is.a_and_b.equal(1, 2),
  false
)

assertMessage(
  is.a_and_b.a_larger(1, 2),
  false
)

assertMessage(
  is.a_and_b.b_larger(1, 2),
  true
)

assertMessage(
  returnLast({1, 2, 3}),
  3
)

assertMessage(
  returnEmpty({1, 2, 3}),
  {}
)

assertMessage(
  returnEmpty("fooo"),
  ""
)

assertMessage(
  returnAnd(true, true),
  true
)

assertMessage(
  returnAnd(true, false),
  false
)

assertMessage(
  returnOr(true, false),
  true
)

assertMessage(
  whole("foo"),
  "^foo$"
)

assertMessage(
  select(2, returnUnpack({1, 2, 3})),
  2
)

assertMessage(
  returnPack(1, 2, 3),
  {1, 2, 3}
)

assertMessage(
  returnUnpackIfTable("foo"),
  "foo"
)

assertMessage(
  returnUnpackIfTable({ "foo" }),
  "foo"
)

assertMessage(
  select(2, returnUnpackIfTable({ "foo", "bar" })),
  "bar"
)