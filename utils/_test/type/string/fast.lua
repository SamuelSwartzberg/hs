assert(
  anyOfFast(
    "lollololol",
    {"!", "d"}
  ) == false
)

assert(
  anyOfFast(
    "lollololol",
    {"!", "d", "l"}
  ) == true
)

assert(
  allOfFast(
    "lollololol",
    {"!", "d"}
  ) == false
)

assert(
  allOfFast(
    "lollololol",
    {"!", "d", "l"}
  ) == false
)

assert(
  allOfFast(
    "lollololol",
    {"l", "o"}
  ) == true
)

assert(
  startsEndsWithFast(
    "I hold these truths to be self-evident.",
    "C",
    "r"
  ) == false
)

assert(
  startsEndsWithFast(
    "I hold these truths to be self-evident.",
    "I",
    "r"
  ) == false
)

assert(
  startsEndsWithFast(
    "I hold these truths to be self-evident.",
    "I",
    "."
  ) == true
)