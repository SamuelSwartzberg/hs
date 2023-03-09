assertValuesContainExactly(
  bind(returnPack, "foo")("bar"),
  {"foo", "bar"}
)

assertValuesContainExactly(
  bind(returnPack, {["1"] = "foo"})("bar"),
  {"foo", "bar"}
)

assertValuesContainExactly(
  bind(returnPack, {["1"] = {"foo"}})("bar"),
  {"foo", "bar"}
)

assertValuesContainExactly(
  bind(returnPack, {["1"] = {"foo", "bar"}})("baz"),
  {"foo", "bar", "baz"}
)

assertValuesContainExactly(
  bind(returnPack, {["1"] = {"foo", "bar"}, ["2"] = "baz"})("qux"),
  {"foo", "baz", "qux"}
)

assertValuesContainExactly(
  bind(returnPack, {["2"] = {"foo", "bar"}})("baz"),
  {"baz", "foo", "bar"}
)

assertValuesContainExactly(
  bind(returnPack, {["1"] = {"foo", "bar"}, ["2"] = {"baz", "qux"}})(),
  {"foo", "baz", "qux"}
)

assertValuesContainExactly(
  bind(returnPack, {["1"] = arg_ignore})("foo", "bar"),
  {"bar"}
)