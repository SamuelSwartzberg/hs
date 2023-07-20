assertMessage(
  get.fn.arbitrary_args_bound_or_ignored_fn(transf.n_anys.array, "foo")("bar"),
  {"foo", "bar"}
)
assertMessage(
  get.fn.arbitrary_args_bound_or_ignored_fn(transf.n_anys.array, {"foo"})("bar"),
  {"foo", "bar"}
)

assertMessage(
  get.fn.arbitrary_args_bound_or_ignored_fn(transf.n_anys.array, {"foo"})("bar"),
  {"foo", "bar"}
)

assertMessage(
  get.fn.arbitrary_args_bound_or_ignored_fn(transf.n_anys.array, {"foo", "bar"})("baz"),
  {"foo", "bar", "baz"}
)


assertMessage(
  get.fn.arbitrary_args_bound_or_ignored_fn(transf.n_anys.array, {a_use, "foo", "bar"})("baz"),
  {"baz", "foo", "bar"}
)

assertMessage(
  get.fn.arbitrary_args_bound_or_ignored_fn(transf.n_anys.array, {"foo", a_use, "qux"})("baz"),
  {"foo", "baz", "qux"}
)

assertMessage(
  get.fn.arbitrary_args_bound_or_ignored_fn(string.sub, {a_use, 1, 1})("foo"),
  "f"
)

assertMessage(
  get.fn.arbitrary_args_bound_or_ignored_fn(transf.n_anys.array, {}, 1)("foo", "bar"),
  {"bar"}
)

assertMessage(
  get.fn.arbitrary_args_bound_or_ignored_fn(transf.n_anys.array, {}, {1, 2})("foo", "bar"),
  {}
)

assertMessage(
  get.fn.arbitrary_args_bound_or_ignored_fn(transf.n_anys.array, {"baz"}, {1, 2})("foo", "bar", "moo"),
  {"baz", "moo"}
)