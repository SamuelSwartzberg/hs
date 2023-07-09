assertMessage(
  #transf.native_table_or_nil.key_array(chunk({ 
    a = 1,
    b = 2,
    c = 3,
    d = 4,
    e = 5,
    f = 6,
    g = 7,
  }, 3)[2]),
  3
)

assertMessage(
  #transf.native_table_or_nil.key_array(chunk({ 
    a = 1,
    b = 2,
    c = 3,
    d = 4,
    e = 5,
    f = 6,
    g = 7,
  }, 3)[3]),
  1
)

assertMessage(
  #transf.native_table_or_nil.key_array(chunk({ 
    a = 1,
    b = 2,
    c = 3,
    d = 4,
    e = 5,
    f = 6,
    g = 7,
  }, 1)[3]),
  1
)

assertMessage(
  #transf.native_table_or_nil.key_array(chunk({ 
    a = 1,
    b = 2,
    c = 3,
    d = 4,
    e = 5,
    f = 6,
    g = 7,
  }, 7)[1]),
  7
)

assertMessage(
  #transf.native_table_or_nil.key_array(chunk({ 
    a = 1,
    b = 2,
    c = 3,
    d = 4,
    e = 5,
    f = 6,
    g = 7,
  }, 8)[1]),
  7
)

assertMessage(
  concat(
    {
      a = 1,
      b = 2
    },
    {
      c = 3,
      d = 4
    }
  ),
  {
    a = 1,
    b = 2,
    c = 3,
    d = 4
  }
)


assertMessage(
  concat(
    {
      {
        foo = "bar",
        baz = "qux"
      }
    },
    {
      {
        foo = "roar",
        baz = "rrrr"
      }
    }
  ),
  {
    {
      foo = "bar",
      baz = "qux"
    },
    {
      foo = "roar",
      baz = "rrrr"
    }
  }
)


assertMessage(
  concat({{1, 2}}, nil), -- since nil doesn't count as a value, we need to wrap the list as if it is was the only arg
  {1, 2}
)

assertMessage(
  concat({1, 2}, false),
  {1, 2, false}
)

assertMessage(
  concat({1, 2}, { a  = 1}),
  {1, 2, { a = 1}}
)

assertMessage(
  concat({1, 2}, {3, 4}),
  {1, 2, 3, 4}
)

assertMessage(
  concat({1, 2}, {{3, 4}}),
  {1, 2, {3, 4}}
)


assertMessage(
  concat(
    {
      isopts = "isopts",
      sep = "|",
    },
    {1, 2},
    4,
    {5, 6}
  ),
  {1, 2, "|", 4, "|", 5, 6}
)