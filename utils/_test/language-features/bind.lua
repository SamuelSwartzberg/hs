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
  bind(string.sub, {a_use, 1, 1})("foo"),
  "f"
)

assertMessage(
  bind(returnPack, {}, 1)("foo", "bar"),
  {"bar"}
)

assertMessage(
  bind(returnPack, {}, {1, 2})("foo", "bar"),
  {}
)

assertMessage(
  bind(returnPack, {"baz"}, {1, 2})("foo", "bar", "moo"),
  {"baz", "moo"}
)