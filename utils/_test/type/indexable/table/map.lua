
assertMessage(
  map({ 1, 2, 3 }, returnAdd1),
  { 2, 3, 4 }
)

assertMessage(
  map({ a = 1, b = 2, c = 3 }, returnAdd1),
  { a = 2, b = 3, c = 4 }
)

assertMessage(
  map({ 1, 2, 3 }, function(value) return { value + 1 } end),
  { { 2 }, { 3 }, { 4 } }
)

assertMessage(
  map({ a = 1, b = 2, c = 3 }, function(value) return { value + 1 } end),
  { a = { 2 }, b = { 3 }, c = { 4 } }
)

assertMessage(
  map({ 1, 2, 3, 4, 5 }, returnAdd1,  { start = 2, stop = 4 }),
  { 3, 4, 5 }
)

local ov1_5 = ovtable.new()

ovtable.a = 1
ovtable.b = 2
ovtable.c = 3
ovtable.d = 4
ovtable.e = 5

assertMessage(
  map(ov1_5, returnAdd1,  { start = 2, stop = 4 }),
  { 
    b = 3,
    c = 4,
    d = 5
  }
)

assertMessage(
  map(ov1_5, returnAdd1,  { start = 2, stop = 4, last = true }),
  { 
    d = 5,
    c = 4,
    b = 3
  }
)

assertMessage(
  map(
    {
      a = { value = "foo" },
      b = "bar",
      c = {
        g = "meep",
        h = {
          i = { value = "blue", distracting_key = "foo" },
          j = "pink"
        }
      },
      d = {},
      e = {
        f = "baz"
      }
    },
    { _k = "value", _ret = "orig" },
    { recurse = true, treat_as_leaf = "list" }
  ),
  
  {
    a = "foo",
    b = "bar",
    c = {
      g = "meep",
      h = {
        i = "blue",
        j = "pink"
      }
    },
    d = {},
    e = {
      f = "baz"
    }
  }
  
)

assertMessage(
  map(
    {
      a = { value = "foo" },
      b = "bar",
      c = {
        g = "meep",
        h = {
          i = { value = "blue", distracting_key = "foo" },
          j = "pink"
        }
      },
      d = {},
      e = {
        f = "baz"
      }
    },
    { _k = "value" },
    { recurse = true, treat_as_leaf = "list" }
  ),
  {
    a = "foo",
    c = {
      h = {
        i = "blue",
      }
    },
  }
)



assertValuesContainExactly(
  map(powerset({1, 2, 3}), function(x) return multiply(x, 2) end),
  {
    {},
    {1, 1},
    {2, 2},
    {3, 3},
    {2, 1, 2, 1},
    {3, 1, 3, 1},
    {3, 2, 3, 2},
    {3, 2, 1, 3, 2, 1},
  }
)

assertMessage(
  map(
    {
      x = 1,
      y = 2,
      w = 3,
      h = 4
    },
    {
      x = "screenX",
      y = "screenY",
      w = "width",
      h = "height"
    },
    { "k", "k" }
  ),
  {
    screenX = 1,
    screenY = 2,
    width = 3,
    height = 4
  }
)


assertMessage(
  map({
    a = " 1 ",
    b = "2",
    c = "ro aaa r   ",
    d = 3
  }, stringy.strip, {
    mapcondition = { _type = "string"}
  }),
  {
    a = "1",
    b = "2",
    c = "ro aaa r",
    d = 3
  }
)

assertMessage(
  map({ 1, 2 , 3}, function(item) return false, {item, item + 1} end, {
    args = "k",
    ret = "kv",
    flatten = true
  }),
  {1, 2, 2, 3, 3, 4}
)

assertMessage(
  map({1,2,3}, function(x) return x end),
  {1,2,3}
)
