assertMessage(
  join.string.table.with_yaml_metadata("foo\nbar"),
  "foo\nbar"
)

assertMessage(
  join.string.table.with_yaml_metadata("foo\nbar", {}),
  "foo\nbar"
)

assertMessage(
  join.string.table.with_yaml_metadata("foo\nbar", {foo = "bar"}),
  "---\nfoo: bar\n---\nfoo\nbar"
)

assertMessage(
  join.string.table.with_yaml_metadata("foo\nbar", {foo = "bar", bar = "baz"}),
  "---\nfoo: bar\nbar: baz\n---\nfoo\nbar"
)

assertMessage(
  join.string.table.with_yaml_metadata(nil, {foo = "bar", bar = "baz"}),
  "---\nfoo: bar\nbar: baz\nbaz: foo\n---\n"
)

assertMessage(
  join.string.table.with_yaml_metadata("---\nauthor: trans rights\n---\n\nsomecontent", {foo = "bar", bar = "baz"}),
  "---\nauthor: trans rights\nfoo: bar\nbar: baz\n---\n\nsomecontent"
)