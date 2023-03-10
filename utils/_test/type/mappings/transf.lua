assertMessage(
  transf.string.tilde_resolved("~"),
  env.HOME
)

assertMessage(
  transf.string.tilde_resolved("~/foo/bar"),
  env.HOME .. "/foo/bar"
)

assertMessage(
  transf.string.tilde_resolved("/~/foo/bar"),
  "/~/foo/bar"
)