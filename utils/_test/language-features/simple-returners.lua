assertMessage(
  transf["nil"]["true"](),
  true
)

assertMessage(
  transf["nil"]["false"](),
  false
)

assertMessage(
  transf.boolean.negated(true),
  false
)

assertMessage(
  transf.any.boolean("foo"),
  true
)

assertMessage(
  transf.any.boolean(nil),
  false
)

assertMessage(
  transf['nil']['nil'](),
  nil
)

assertMessage(
  transf['nil'].empty_string(),
  ""
)


assertMessage(
  transf['nil'].empty_table(),
  {}
)

assertMessage(
  transf['nil'].zero(),
  0
)

assertMessage(
  transf['nil'].one(),
  1
)

assertMessage(
  transf.any.same(1),
  1
)

assertMessage(
  transf.any.same("foo"),
  "foo"
)

assertMessage(
  select(2, returnAny(1, 2, 3)),
  2
)

assertMessage(
  select(4, get.any.repeated("foo", 5)),
  "foo"
)

assertMessage(
  select(6, get.any.repeated("foo", 5)),
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
  transf.array.last({1, 2, 3}),
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
  transf.a_and_b.boolean_and(true, true),
  true
)

assertMessage(
  transf.a_and_b.boolean_and(true, false),
  false
)

assertMessage(
  transf.a_and_b.boolean_or(true, false),
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
  transf.n_anys.array(1, 2, 3),
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