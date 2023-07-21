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
  select(2, transf.n_anys.n_anys(1, 2, 3)),
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
  transf.n_anys.amount(1, 2, 3),
  3
)

assertMessage(
  is.two_comparables.equal(1, 1),
  true
)

assertMessage(
  is.two_comparables.equal(1, 2),
  false
)

assertMessage(
  is.two_anys.a_larger(1, 2),
  false
)

assertMessage(
  is.two_anys.b_larger(1, 2),
  true
)

assertMessage(
  transf.array.last({1, 2, 3}),
  3
)

assertMessage(
  transf.indexable.unspecified_equivalent_empty_indexable({1, 2, 3}),
  {}
)

assertMessage(
  transf.indexable.unspecified_equivalent_empty_indexable("fooo"),
  ""
)

assertMessage(
  transf.two_anys.boolean_and(true, true),
  true
)

assertMessage(
  transf.two_anys.boolean_and(true, false),
  false
)

assertMessage(
  transf.two_anys.boolean_or(true, false),
  true
)

assertMessage(
  transf.string.whole_regex("foo"),
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
  transf.any.n_anys_if_table("foo"),
  "foo"
)

assertMessage(
  transf.any.n_anys_if_table({ "foo" }),
  "foo"
)

assertMessage(
  select(2, transf.any.n_anys_if_table({ "foo", "bar" })),
  "bar"
)