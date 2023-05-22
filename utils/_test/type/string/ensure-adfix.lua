assertMessage(
  ensureAdfix("foo", "a"),
  "afoo"
)

assertMessage(
  ensureAdfix("foo", "a", true),
  "afoo"
)

assertMessage(
  ensureAdfix("afoo", "a", true),
  "afoo"
)

assertMessage(
  ensureAdfix("afoo", "a", false),
  "foo"
)

assertMessage(
  ensureAdfix("afoo", "a", false, true),
  "foo"
)

assertMessage(
  ensureAdfix("Afoo", "a", false, true),
  "foo"
)

assertMessage(
  ensureAdfix("foo", "a", true, true),
  "afoo"
)

assertMessage(
  ensureAdfix("Afoo", "a", true, true),
  "Afoo"
)

assertMessage(
  ensureAdfix("Afoo", "a", true, false),
  "aAfoo"
)

assertMessage(
  ensureAdfix("Afoo", "a", false, false),
  "Afoo"
)

assertMessage(
  ensureAdfix("Afoo", "bar", true, false, "suf"),
  "Afoobar"
)

assertMessage(
  ensureAdfix("Afoo", "bar", true, false, "pre"),
  "barAfoo"
)

assertMessage(
  ensureAdfix("Afoo", "bar", false, false, "suf"),
  "Afoo"
)

assertMessage(
  ensureAdfix("Afoobar", "bar", false, false, "suf"),
  "Afoo"
)

assertMessage(
  ensureAdfix("AfoobAr", "bar", false, false, "suf"),
  "AfoobAr"
)

assertMessage(
  ensureAdfix("AfoobAr", "bar", false, true, "suf"),
  "Afoo"
)

assertMessage(
  ensureAdfix("AfoobAr", "foo", false, false, "in"),
  "AbAr"
)

assertMessage(
  ensureAdfix("AfoobAr", "oba", false, true, "in"),
  "Afor"
)

assertMessage(
  mustEnd("foo/bar", "/"),
  "foo/bar/"
)

assertMessage(
  mustEnd("foo/bar/", "/"),
  "foo/bar/"
)

assertMessage(
  mustStart("foo/bar", "/"),
  "/foo/bar"
)

assertMessage(
  mustStart("/foo/bar", "/"),
  "/foo/bar"
)