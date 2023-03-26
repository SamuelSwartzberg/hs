assertMessage(
  map({ "foo", "bar", "baz" }, { _f = "%s!"}),
  { "foo!", "bar!", "baz!" }
)

assertMessage(
  map({ "foo", "bar", "baz" }, "lol"),
  { "lol", "lol", "lol" }
)

assertMessage(
  map(
    { 
      { foo = 1 }, 
      {notfoo = 2} , 
      { foo = 3 } 
    }, 
    { _k = "foo" }
  ),
  { 1, [3] = 3 }
)

assertMessage(
  map(
    { 
      { foo = 1 }, 
      {notfoo = 2} , 
      { foo = 3 }
    }, 
    { _k = "foo", _ret = "orig" }
  ),
  { 1, {notfoo = 2}, 3 }
)

assertMessage(
  map(
    {"foo", "bar", "baz"}, 
    {
      foo = "sore",
      bar = "mo",
      baz = "ii",
      quux = "janai?"
    }
  ),
  { "sore", "mo", "ii" }
)

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
  { nil, 3, 4, 5 }
)

local ov1_5 = ovtable.new()

ov1_5.a = 1
ov1_5.b = 2
ov1_5.c = 3
ov1_5.d = 4
ov1_5.e = 5

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
    e = {} -- this happens because it recurses into the table, but then none of its pairs match the condition. It would be trivial to test for recursive calls returning an empty table and not adding it to the result, but I'm not sure if that's the right thing to do. Let's leave this for now, and keep an eye on it.
  }
)



assertMessage(
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
  map({ a = 1, b = 2 , c = 3}, function(item) return false, {item, item + 1} end, {
    args = "v",
    ret = "kv",
  }),
  {{1, 2}, {2, 3}, {3, 4}}
)

print("START")

assertMessage(
  map({ {1}, {2}, {3}}, returnSame, {
    flatten = true,
    tolist = true
  }),
  {1, 2, 3}
)

assertMessage(
  map({ {1}, {2}, {3}}, returnSame, {
    flatten = true,
  }),
  {3} -- without tolist, this is the intended behavior, but it's not very intuitive. Consider changing this.
)

assertMessage(
  map({ 2, 5 , 8}, function(item) return {item, item + 1} end, {
    args = "k",
    ret = "v",
    flatten = true
  }),
  {3, 4} -- see above tolist comment
)


assertMessage(
  map({ 2, 5, 8}, function(item) return {item, item + 1} end, {
    args = "k",
    ret = "v",
    flatten = true,
    tolist = true
  }),
  {1, 2, 2, 3, 3, 4}
)

assertMessage(
  map({1,2,3}, function(x) return x end),
  {1,2,3}
)

assertMessage(
  map({ a = 1, b = 2, c = 3 }, returnSame, { tolist = true }),
  { 1, 2, 3 }
)

local tmpovtable = ovtable.new()
tmpovtable.a = 1
tmpovtable.b = 2
tmpovtable.c = 3

local mappedtable = map(tmpovtable, returnSame, { output = "table" })

assertMessage(
  mappedtable.isovtable,
  nil
)

-- todo: if this test errors, maybe it only works with ovtables?
local tblwithduplicatevalues = {
  a = "a",
  b = "b",
  c = "c",
  d = "a",
  e = "b",
  f = "c"
}

assertMessage(
  map(tblwithduplicatevalues, returnSame, { arg = "k", ret = "v" }),
  { d = "a", e = "b", f = "c" }
)

assertMessage(
  map(tblwithduplicatevalues, returnSame, { arg = "k", ret = "v", nooverwrite = true }),
  { a = "a", b = "b", c = "c" }
)