-- options

local abc = { "a", "b", "c" }
local a_to_t = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t" }

assertMessage(
  filter(abc, { _type = "string"}, "v"),
  { "a", "b", "c" }
)

assertMessage(
  filter(abc, { _type = "string"}, "k"),
  {}
)

assertMessage(
  filter(a_to_t, isEven, {"k", "v"}),
  { "b", "d", "f", "h", "j", "l", "n", "p", "r", "t" }
)

assertMessage(
  filter(a_to_t, isEven, {
    args = "k",
    ret = "k"
  }),
  { "b", "d", "f", "h", "j", "l", "n", "p", "r", "t" }
)

local sometable = ovtable.new()
sometable.a = 1
sometable.b = 2
sometable.c = 3
sometable.d = 4
sometable.e = 5

assertMessage(
  filter(sometable, isEven),
  {
    b = 2,
    d = 4
  }
)

assertMessage(
  filter(sometable, isEven, {
    tolist = true
  }),
  { 2, 4 }
)

assertMessage(
  filter(sometable, isEven, {
    tolist = true,
    last = true
  }),
  { 4, 2 }
)

assertMessage(
  filter(sometable, isEven, {
    tolist = true,
    last = true,
    start = 3
  }),
  { 4 }
)

assertMessage(
  filter(sometable, isEven, {
    tolist = true,
    last = true,
    stop = 3
  }),
  { 2 }
)

local noov_filtered = filter(sometable, isEven, {
  noovtable = true
})

assertMessage(
  noov_filtered,
  {
    b = 2,
    d = 4
  }
)

assertMessage(
  noov_filtered.revpairs,
  nil
)
-- conditions

assertMessage(
  filter(
    list_with_various_strings,
    { _contains = "..."}
  )
  {"Omae wa mou...", "...shindeiru"}
)

assertMessage(
  filter(
    list_with_various_strings,
    { _r = " \\w+ " }
  ),
  {
    "Kore ha kore de oishii",
    "the quick brown fox jumps over the lazy dog",
    "Omae wa mou...",
  }
)

assertMessage(
  filter(
    list_with_various_strings,
    { _type = "number" }
  ),
  {738}
)

-- shorthands

assertMessage(
  filter({1, "", 2, "", 3}, true),
  {1, 2, 3}
)

assertMessage(
  filter({1, " ", 2, " ", 3}, true),
  {1, " ", 2, " ", 3}
)

assertMessage(
  filter({1, 2, 3}, true),
  {1, 2, 3}
)

assertMessage(
  filter({1, 2, 3}, false),
  {}
)


assertMessage(
  filter({1, "", 2, "", 3}, false),
  {"", "", ""}
)

assertMessage(
  filter({1, 2, 3}, 3),
  {3}
)

assertMessage(
  filter({1, 2, 3}, 4),
  {}
)

assertMessage(
  filter({1, 2, 3, 1 }, 1),
  {1, 1}
)

assertMessage(
  filter({1, 2, 3, 4, 5}, { 2, 3, 4}),
  {2, 3, 4}
)


assertMessage(
  filter({1, 2, 3, 4, 5}, { 6, 7, 8}),
  {}
)