assert(
  get.string.contains_any(
    "lollololol",
    {"!", "d"}
  ) == false
)

assert(
  get.string.contains_any(
    "lollololol",
    {"!", "d", "l"}
  ) == true
)

assert(
  get.string.contains_all(
    "lollololol",
    {"!", "d"}
  ) == false
)

assert(
  get.string.contains_all(
    "lollololol",
    {"!", "d", "l"}
  ) == false
)

assert(
  get.string.contains_all(
    "lollololol",
    {"l", "o"}
  ) == true
)

assert(
  get.string.starts_ends(
    "I hold these truths to be self-evident.",
    "C",
    "r"
  ) == false
)

assert(
  get.string.starts_ends(
    "I hold these truths to be self-evident.",
    "I",
    "r"
  ) == false
)

assert(
  get.string.starts_ends(
    "I hold these truths to be self-evident.",
    "I",
    "."
  ) == true
)