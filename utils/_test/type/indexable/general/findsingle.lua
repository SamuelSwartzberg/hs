-- for tables:

-- test conditions with boolean return values

list_with_various_strings = {
  "Kore ha kore de oishii",
  "lower_snake_case",
  738,
  "the quick brown fox jumps over the lazy dog",
  "Omae wa mou...",
  '...shindeiru',
  "Nani?",
  "",
  "*explodes*"
} -- we only need single items here, but this list is also used for find()

assertMessage(
  findsingle(
    list_with_various_strings[2],
    { _r  = mt._r.case.lower_snake }
  ),
  true
)

assertMessage(
  findsingle(
    list_with_various_strings[2],
    { _r  = mt._r.case.lower_snake, _invert = true }
  ),
  false
)

assertMessage(
  findsingle(
    list_with_various_strings[2],
    { _r  = mt._r.case.lower_snake, _only_if_all = true }
  ),
  true
)

assertMessage(
  findsingle(
    list_with_various_strings[1],
    { _r  = mt._r.case.lower_snake, _only_if_all = false }
  ),
  true
)

assertMessage(
  findsingle(
    list_with_various_strings[1],
    { _r  = mt._r.case.lower_snake, _only_if_all = true }
  ),
  false
)

assertMessage(
  findsingle(
    list_with_various_strings[1],
    { _r  = mt._r.case.lower_snake, _only_if_all = true, _invert = true }
  ),
  true
)

assertMessage(
  findsingle(
    list_with_various_strings[1],
    { _r  = mt._r.case.upper_snake, _ignore_case = true }
  ),
  true
)

assertMessage(
  findsingle(
    list_with_various_strings[1],
    { _r  = mt._r.case.upper_snake, _ignore_case = true, _invert = true }
  ),
  false
)

assertMessage(
  findsingle(
    list_with_various_strings[1],
    { _start = "Kore" }
  ),
  true
)

assertMessage(
  findsingle(
    list_with_various_strings[1],
    { _start = "Kore", _invert = true }
  ),
  false
)

assertMessage(
  findsingle(
    list_with_various_strings[1],
    { _start = "kore" }
  ),
  false
)

assertMessage(
  findsingle(
    list_with_various_strings[1],
    { _start = "kore", _invert = true }
  ),
  true
)

assertMessage(
  findsingle(
    list_with_various_strings[1],
    { _start = "kore", _ignore_case = true }
  ),
  true
)

assertMessage(
  findsingle(
    list_with_various_strings[1],
    { _start = "Kore", _only_if_all = true }
  ),
  false -- false by necessity: The string is longer than the start condition, so _only_if_all (which specifies that the condition must be met for the entire string) cannot be met.
)

assertMessage(
  findsingle(
    list_with_various_strings[6],
    { _stop = "...shindeiru" }
  ),
  true
)

assertMessage(
  findsingle(
    list_with_various_strings[6],
    { _stop = "...shindeiru", _invert = true }
  ),
  false
)

assertMessage(
  findsingle(
    list_with_various_strings[6],
    { _stop = "...ShindeIru", _ignore_case = true }
  ),
  true
)

assertMessage(
  findsingle(
    list_with_various_strings[6],
    { _stop = "...shindeiru", _only_if_all = true }
  ),
  true
)

assertMessage(
  findsingle(
    list_with_various_strings[6],
    { _stop = "...shindeiru", _only_if_all = true, _invert = true }
  ),
  false
)

assertMessage(
  findsingle(
    list_with_various_strings[6],
    { _stop = "...shindeiru", _only_if_all = false }
  ),
  true
)

assertMessage(
  findsingle(
    list_with_various_strings[6],
    { _stop = "...shindeiru", _only_if_all = false, _invert = true }
  ),
  false
)

assertMessage(
  findsingle(
    list_with_various_strings[6],
    { _contains = "..." }
  ),
  true
)

assertMessage(
  findsingle(
    list_with_various_strings[6],
    { _contains = "...." }
  ),
  false
)

assertMessage(
  findsingle(
    list_with_various_strings[6],
    { _contains = "....", _invert = true }
  ),
  true
)

assertMessage(
  findsingle(
    list_with_various_strings[7],
    { _contains = "nani?" }
  ),
  false
)

assertMessage(
  findsingle(
    list_with_various_strings[7],
    { _contains = "nani?", _ignore_case = true }
  ),
  true
)

assertMessage(
  findsingle(
    list_with_various_strings[6],
    { _empty = true }
  ),
  false
)

assertMessage(
  findsingle(
    list_with_various_strings[6],
    { _empty = true, _ignore_case = true }
  ),
  false
)

assertMessage(
  findsingle(
    list_with_various_strings[6],
    { _empty = true, _ignore_case = true, _invert = true }
  ),
  true
)


assertMessage(
  findsingle(
    list_with_various_strings[8],
    { _empty = true }
  ),
  true
)

assertMessage(
  findsingle(
    list_with_various_strings[8],
    { _empty = false }
  ),
  false
)

assertMessage(
  findsingle(
    list_with_various_strings[2],
    { _type = "string" }
  ),
  true
)

assertMessage(
  findsingle(
    list_with_various_strings[2],
    { _type = "string", _invert = true }
  ),
  false
)

assertMessage(
  findsingle(
    list_with_various_strings[3],
    { _type = "string" }
  ),
  false
)

assertMessage(
  findsingle(
    list_with_various_strings[3],
    { _type = "number" }
  ),
  true
)

assertMessage(
  findsingle(
    list_with_various_strings[3],
    { _type = "number", _only_if_all = true }
  ),
  true
)

assertMessage(
  findsingle(
    list_with_various_strings[3],
    { _exactly = 738 }
  ),
  true
)

assertMessage(
  findsingle(
    list_with_various_strings[2],
    { _exactly = "lower_snake_case" }
  ),
  true
)

assertMessage(
  findsingle(
    list_with_various_strings[2],
    { _exactly = "lower_snake_case", _invert = true }
  ),
  false
)

assertMessage(
  findsingle(
    list_with_various_strings[3],
    { _exactly = 739 }
  ),
  false
)

assertMessage(
  findsingle(
    list_with_various_strings[2],
    { _exactly = "lower_snake_casing" }
  ),
  false
)

assertMessage(
  findsingle(
    list_with_various_strings[3],
    { _exactly = "738" }
  ),
  false
)

assertMessage(
  findsingle(
    list_with_various_strings[3],
    { _list = { 737, 738, 739 } }
  ),
  true
)

assertMessage(
  findsingle(
    list_with_various_strings[3],
    { _list = { 737, 739 } }
  ),
  false
)

assertMessage(
  findsingle(
    list_with_various_strings[3],
    { _list = { 737, 739 }, _invert = true }
  ),
  true
)

assertMessage(
  findsingle(
    list_with_various_strings[7],
    { _list = { "nani?", "nani!?", "nani!?!?" } }
  ),
  false
)

assertMessage(
  findsingle(
    list_with_various_strings[7],
    { _list = { "nani?", "nani!?", "nani!?!?", "nani!?!?!?" }, _ignore_case = true }
  ),
  true
)

assertMessage(
  findsingle(
    list_with_various_strings[7],
    { _r = "Nani%?", _regex_engine = "eutf8" }
  ),
  true
)

assertMessage(
  findsingle(
    list_with_various_strings[7],
    function(elem)
      return elem == "Nani?"
    end
  ),
  true
)

-- test the options (tostring, ret)

-- tostring

assertMessage(
  findsingle(
    list_with_various_strings[3],
    { _exactly = "738" },
    { _tostring = true }
  ),
  true
)

assertMessage(
  findsingle(
    list_with_various_strings[2],
    { _exactly = "lower_snake_casing" },
    { _tostring = true }
  ),
  false
)

-- ret

-- reminder: for findsingle, k is the start index, v is the match

assertMessage(
  findsingle(
    list_with_various_strings[2],
    { _r  = mt._r.case.lower_snake },
    "k"
  ),
  1
)

assertMessage(
  findsingle(
    list_with_various_strings[2],
    { _r  = mt._r.case.lower_snake },
    "v"
  ),
  "lower_snake_case"
)

assertValuesContainExactly(
  findsingle(
    list_with_various_strings[2],
    { _r  = mt._r.case.lower_snake },
    "kv"
  ),
  { 1, "lower_snake_case" }
)

assertMessage(
  findsingle(
    list_with_various_strings[2],
    { _r  = mt._r.case.lower_snake, _invert = true },
    "k"
  ),
  -1
)

assertMessage(
  findsingle(
    list_with_various_strings[1],
    { _r  = mt._r.case.lower_snake },
    "v"
  ),
  "ha"
)

assertValuesContainExactly(
  findsingle(
    list_with_various_strings[1],
    { _r  = mt._r.case.lower_snake },
    "kv"
  ),
  { 6, "ha" }
)

assertValuesContainExactly(
  findsingle(
    list_with_various_strings[1],
    { _start = "Kore" },
    "kv"
  ),
  { 1, "Kore" }
)

assertValuesContainExactly(
  findsingle(
    list_with_various_strings[1],
    { _start = "Kore", _invert = true },
    "kv"
  ),
  { -1, false }
)

assertMessage(
  findsingle(
    list_with_various_strings[1],
    { _start = "kore", _ignore_case = true },
    "v"
  ),
  "Kore"
)

assertValuesContainExactly(
  findsingle(
    list_with_various_strings[6],
    { _stop = "iru" },
    "kv"
  ),
  { 10, "iru" }
)

assertValuesContainExactly(
  findsingle(
    list_with_various_strings[6],
    { _contains = "shin" },
    "kv"
  ),
  { 4, "shin" }
)

assertValuesContainExactly(
  findsingle(
    list_with_various_strings[8],
    { _empty = true },
    "kv"
  ),
  { 1, "" }
)

assertValuesContainExactly(
  findsingle(
    list_with_various_strings[6],
    { _empty = false },
    "kv"
  ),
  { 1, "...shindeiru"}
)

assertValuesContainExactly(
  findsingle(
    list_with_various_strings[3],
    { _exactly = 738 },
    "kv"
  ),
  { 1, 738 }
)

assertValuesContainExactly(
  findsingle(
    list_with_various_strings[3],
    { _list = { 737, 738, 739 } },
    "kv"
  ),
  { 1, 738 }
)

assertValuesContainExactly(
  findsingle(
    list_with_various_strings[7],
    { _r = "Nani%?", _regex_engine = "eutf8" },
    "kv"
  ),
  { 1, "Nani?" }
)

assertValuesContainExactly(
  findsingle(
    list_with_various_strings[7],
    function(elem)
      return elem == "Nani?"
    end,
    "kv"
  ),
  { 1, "Nani?" }
)

-- test the shorthand conditions

-- boolean -> _empty

assertValuesContainExactly(
  findsingle(
    list_with_various_strings[8],
    true,
    "kv"
  ),
  { 1, "" }
)

assertValuesContainExactly(
  findsingle(
    list_with_various_strings[6],
    false,
    "kv"
  ),
  { 1, "...shindeiru"}
)

-- string -> _exactly

assertValuesContainExactly(
  findsingle(
    list_with_various_strings[2],
    "lower_snake_case",
    "kv"
  ),
  { 1, "lower_snake_case" }
)

-- number -> _exactly

assertValuesContainExactly(
  findsingle(
    list_with_various_strings[3],
    738,
    "kv"
  ),
  { 1, 738 }
)

-- list -> _list

assertValuesContainExactly(
  findsingle(
    list_with_various_strings[3],
    { 737, 738, 739 },
    "kv"
  ),
  { 1, 738 }
)