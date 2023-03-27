assertMessage(
  bind(returnPack, "foo")("bar"),
  {"foo", "bar"}
)
assertMessage(
  bind(returnPack, {"foo"})("bar"),
  {"foo", "bar"}
)

assertMessage(
  bind(returnPack, {"foo"})("bar"),
  {"foo", "bar"}
)

assertMessage(
  bind(returnPack, {"foo", "bar"})("baz"),
  {"foo", "bar", "baz"}
)


assertMessage(
  bind(returnPack, {a_use, "foo", "bar"})("baz"),
  {"baz", "foo", "bar"}
)

assertMessage(
  bind(returnPack, {"foo", a_use, "qux"})("baz"),
  {"foo", "baz", "qux"}
)

assertMessage(
  bind(returnPack, {}, {a_ig})("foo", "bar"),
  {"bar"}
)

assertMessage(
  bind(returnPack, {}, {a_ig, a_ig})("foo", "bar"),
  {}
)

assertMessage(
  bind(returnPack, {"baz"}, {a_ig, a_ig})("foo", "bar", "moo"),
  {"baz", "moo"}
)