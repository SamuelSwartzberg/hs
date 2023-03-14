assertMessage(
  shellLikeArgsToOpts("-f bar"),
  {f = "bar"}
)

assertMessage(
  shellLikeArgsToOpts("-f bar -b"),
  {f = "bar", b = true}
)

assertMessage(
  shellLikeArgsToOpts("-f bar -b -c"),
  {f = "bar", b = true, c = true}
)

assertMessage(
  shellLikeArgsToOpts("-f bar -b -c -d baz"),
  {f = "bar", b = true, c = true, d = "baz"}
)

assertMessage(
  shellLikeArgsToOpts("-f bar -b -c -d baz baz baz"),
  {f = "bar", b = true, c = true, d = "baz baz baz"}
)

assertMessage(
  shellLikeArgsToOpts("-f bar -b -c -d baz banana -e foo"),
  {f = "bar", b = true, c = true, d = "baz banana", e = "foo"}
)

takeShellikeArgsAsOpts(function (opts)
  assertMessage(opts.france, "bar")
end)("-f bar")

takeShellikeArgsAsOpts(function (opts)
  assertMessage(opts.france, "bar")
  assertMessage(opts.brazil, true)
end)("-f bar -b")

takeShellikeArgsAsOpts(function (opts)
  assertMessage(opts.france, "bar")
  assertMessage(opts.brazil, true)
  assertMessage(opts.canada, true)
end)("-f bar -b -c")

takeShellikeArgsAsOpts(function (opts)
  assertMessage(opts.france, "bar")
  assertMessage(opts.brazil, true)
  assertMessage(opts.canada, true)
  assertMessage(opts.denmark, "baz")
end)("-f bar -b -c -d baz")

takeShellikeArgsAsOpts(function (opts)
  assertMessage(opts.france, "bar")
  assertMessage(opts.brazil, true)
  assertMessage(opts.canada, true)
  assertMessage(opts.denmark, "baz baz baz")
end)("-f bar -b -c -d baz baz baz")

takeShellikeArgsAsOpts(function (opts)
  assertMessage(opts.france, "bar")
  assertMessage(opts.brazil, true)
  assertMessage(opts.canada, true)
  assertMessage(opts.denmark, "baz banana")
  assertMessage(opts.egypt, "foo")
end)("-f bar -b -c -d baz banana -e foo")