assertMessage(
  bind(returnPack, "foo")("bar"),
  {"foo", "bar"}
)

assertMessage(
  bind(returnPack, {["1"] = "foo"})("bar"),
  {"foo", "bar"}
)

assertMessage(
  bind(returnPack, {["1"] = {"foo"}})("bar"),
  {"foo", "bar"}
)

assertMessage(
  bind(returnPack, {["1"] = {"foo", "bar"}})("baz"),
  {"foo", "bar", "baz"}
)

assertMessage(
  bind(returnPack, {["1"] = {"foo", "bar"}, ["2"] = "baz"})("qux"),
  {"foo", "baz", "qux"}
)

assertMessage(
  bind(returnPack, {["2"] = {"foo", "bar"}})("baz"),
  {"baz", "foo", "bar"}
)

assertMessage(
  bind(returnPack, {["1"] = {"foo", "bar"}, ["2"] = {"baz", "qux"}})(),
  {"foo", "baz", "qux"}
)

assertMessage(
  bind(returnPack, {["1"] = arg_ignore})("foo", "bar"),
  {"bar"}
)