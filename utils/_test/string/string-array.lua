
assertMessage(
  toUrlParams({a = "b", c = "d"}, "initial"),
  "?a=b&c=d"
)

assertMessage(
  toUrlParams({a = "b", c = "d"}, "append"),
  "&a=b&c=d"
)

assertMessage(
  toUrlParams({a = "b", c = "d"}),
  "a=b&c=d"
)