assertMessage(
  bind(transf.n_anys.array, "foo")("bar"),
  {"foo", "bar"}
)
assertMessage(
  bind(transf.n_anys.array, {"foo"})("bar"),
  {"foo", "bar"}
)

assertMessage(
  bind(transf.n_anys.array, {"foo"})("bar"),
  {"foo", "bar"}
)

assertMessage(
  bind(transf.n_anys.array, {"foo", "bar"})("baz"),
  {"foo", "bar", "baz"}
)


assertMessage(
  bind(transf.n_anys.array, {a_use, "foo", "bar"})("baz"),
  {"baz", "foo", "bar"}
)

assertMessage(
  bind(transf.n_anys.array, {"foo", a_use, "qux"})("baz"),
  {"foo", "baz", "qux"}
)

assertMessage(
  bind(string.sub, {a_use, 1, 1})("foo"),
  "f"
)

assertMessage(
  bind(transf.n_anys.array, {}, 1)("foo", "bar"),
  {"bar"}
)

assertMessage(
  bind(transf.n_anys.array, {}, {1, 2})("foo", "bar"),
  {}
)

assertMessage(
  bind(transf.n_anys.array, {"baz"}, {1, 2})("foo", "bar", "moo"),
  {"baz", "moo"}
)