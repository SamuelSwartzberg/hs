-- options

local abc = { "a", "b", "c" }
local a_to_t = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t" }

assertMessage(
  filter(abc, { _type = "string"}, {"v"}),
  { "a", "b", "c" }
)

assertMessage(
  filter(abc, { _type = "string"}, {"k"}),
  {}
)

assertMessage(
  filter(a_to_t, isEven, {args = "k", tolist = true}),
  { "b", "d", "f", "h", "j", "l", "n", "p", "r", "t" }
)

assertMessage(
  filter(a_to_t, isEven, {"k"}),
  {
    [2] = "b",
    [4] = "d",
    [6] = "f",
    [8] = "h",
    [10] = "j",
    [12] = "l",
    [14] = "n",
    [16] = "p",
    [18] = "r",
    [20] = "t"
  }
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
  output = "table"
})

assertMessage(
  noov_filtered,
  {
    b = 2,
    d = 4
  }
)

assertMessage(
  noov_filtered.isovtable,
  nil
)
-- conditions
assertMessage(
  filter(
    list_with_various_strings,
    { _contains = "..." },
    {tolist = true}
  ),
  {"Omae wa mou...", "...shindeiru"}
)
assertMessage(
  filter(
    list_with_various_strings,
    { _contains = "..." }
  ),
  {[5] = "Omae wa mou...", [6] = "...shindeiru"}
)

assertMessage(
  filter(
    list_with_various_strings,
    { _r = " \\w+ " },
    {tolist = true}
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
    { _type = "number" },
    {tolist = true}
  ),
  {738}
)

-- shorthands

assertMessage(
  filter({1, "", 2, "", 3}, false, {tolist = true}),
  {1, 2, 3}
)

assertMessage(
  filter({1, " ", 2, " ", 3}, false),
  {1, " ", 2, " ", 3}
)

assertMessage(
  filter({1, 2, 3}, false),
  {1, 2, 3}
)

assertMessage(
  filter({1, 2, 3}, true),
  {}
)


assertMessage(
  filter({1, "", 2, "", 3}, true, {tolist = true}),
  {"", ""}
)

assertMessage(
  filter({1, 2, 3}, 3, {tolist = true}),
  {3}
)

assertMessage(
  filter({1, 2, 3}, 4),
  {}
)

assertMessage(
  filter({1, 2, 3, 1 }, 1, {tolist = true}),
  {1, 1}
)

assertMessage(
  filter({1, 2, 3, 4, 5}, {{ 2, 3, 4}}, {tolist = true}),
  {2, 3, 4}
)


assertMessage(
  filter({1, 2, 3, 4, 5}, {{ 6, 7, 8}}, {tolist = true}),
  {}
)