
assertMessage(
  
    flatten(
      {
        a = 1,
        b = {
          c = 2,
          d = {
            e = 3,
            f = 4
          }
        }
      },
      {
        treat_as_leaf = false,
        mode = "list",
      }
  ),
  { 1, 2, 3, 4 }
)

assertMessage(
  flatten(
    {
      1,
      2,
      {
        3,
        {
          4
        },
        5
      }
    },
    {
      treat_as_leaf = false,
      mode = "list",
    }
  ),
  { 1, 2, 3, 4, 5 }
)

assertMessage(
  flatten(
    {
      1,
      2,
      {
        {
          foo = "bar"
        },
        {
          4
        },
        5
      }
    },
    {
      treat_as_leaf = "assoc",
      mode = "list",
    }
  ),
  { 
    1,
    2,
    {
      foo = "bar"
    },
    4,
    5
  }
)

assertMessage(
  flatten(
    {
      1,
      2,
      {
        {
          foo = "bar"
        },
        {
          4 -- equivalent to { [1] = 4 }
        },
        5 -- equivalent to [3] = 5
      }
    },
    {
      treat_as_leaf = false,
      mode = "assoc",
    }
  ),
  {
    [2] = 2,
    foo = "bar",
    [1] = 4,
    [3] = 5
  }
)

assertMessage(
  flatten(
    {
      a = {
        b = {
          c = 1,
          d = {"a", "b", "c"}
        },
        e = {"d" , "e", "f"}
      },
      f = 4
    },
    {
      treat_as_leaf = false,
      mode = "list",
    }
  ),
  { 1, "a", "b", "c", "d", "e", "f", 4 }
)

assertMessage(
  flatten(
    {
      a = {
        b = {
          c = 1,
          d = {"a", "b", "c"}
        },
        e = {"d" , "e", "f"}
      },
      f = 4
    },
    {
      treat_as_leaf = false,
      mode = "assoc",
    }
  ),
  {
    c = 1,
    [1] = "d",
    [2] = "e",
    [3] = "f",
    f = 4
  }
)

assertMessage(
  flatten(
    {
      a = {
        b = {
          c = 1,
          d = {"a", "b", "c"}
        },
        e = {"d" , "e", "f"}
      },
      f = 4
    },
    {
      treat_as_leaf = false,
      mode = "assoc",
      nooverwrite = true
    }
  ),
  {
    c = 1,
    [1] = "a",
    [2] = "b",
    [3] = "c",
    f = 4
  }
)

assertMessage(
  flatten(
    {
      a = {
        b = {
          c = 1,
          d = 2
        },
        e = 3
      },
      f = 4
    },
    {
      treat_as_leaf = false,
      mode = "assoc",
      recurse = false,
      val = "path"
    }
  ),
  {
    a = {
      path = {"a"},
      value = {
        b = {
          c = 1,
          d = 2
        },
        e = 3
      }
    },
    f = {
      path = {"f"},
      value = 4
    }
  }
)

assertMessage(
  flatten(
    {
      a = {
        b = {
          c = 1,
          d = 2
        },
        e = 3
      },
      f = 4
    },
    {
      treat_as_leaf = false,
      mode = "assoc",
      recurse = 1,
      val = "path"
    }
  ),
  {
    b = {
      path = {"a", "b"},
      value = {
        c = 1,
        d = 2
      }
    },
    e = {
      path = {"a", "e"},
      value = 3
    },
    f = {
      path = {"f"},
      value = 4
    }
  }
)


assertMessage(
  flatten(
    {
      a = {
        b = {
          c = 1,
          d = 2
        },
        e = 3
      },
      f = 4
    },
    {
      treat_as_leaf = false,
      mode = "list",
      val = "path",
    }
  ),
  {
    {
      path = {"a", "b", "c"},
      value = 1
    },
    {
      path = {"a", "b", "d"},
      value = 2
    },
    {
      path = {"a", "e"},
      value = 3
    },
    {
      path = {"f"},
      value = 4
    }
  }
)
assertMessage(
  flatten(
    {
      a = {
        b = {
          c = 1,
          d = 2
        },
        e = 3
      },
      f = 4
    },
    {
      treat_as_leaf = false,
      mode = "list",
      val = { "path", "depth", "value" },
    }
  ),
  {
    {
      path = {"a", "b", "c"},
      value = 1,
      depth = 2
    },
    {
      path = {"a", "b", "d"},
      value = 2,
      depth = 2
    },
    {
      path = {"a", "e"},
      value = 3,
      depth = 1
    },
    {
      path = {"f"},
      value = 4,
      depth = 0
    }
  }
)

assertMessage(
  flatten(
    {
      a = {
        b = {
          c = 1,
          d = 2
        },
        e = 3
      },
      f = 4
    },
    {
      treat_as_leaf = false,
      mode = "list",
      val = { "path", "depth", "value"},
      join_path = ".",
    }
  ),
  {
    {
      path = "a.b.c",
      value = 1,
      depth = 2
    },
    {
      path = "a.b.d",
      value = 2,
      depth = 2
    },
    {
      path = "a.e",
      value = 3,
      depth = 1
    },
    {
      path = "f",
      value = 4,
      depth = 0
    }
  }
)

assertMessage(
  flatten({
    a = {
      b = {
        c = 1,
        d = 2
      },
      e = 3
    },
    f = 4
  }, {
    mode = "path-assoc",
    val = "plain",
    join_path = ".",
    treat_as_leaf = false,
  }),
  {
    ["a.b.c"] = 1,
    ["a.b.d"] = 2,
    ["a.e"] = 3,
    ["f"] = 4
  }
)

assertMessage(
  flatten({
    l = {
      lll = "vvvvv",
      l = {
        ll = "vvv"
      }, 
      llllll = "vv"
    },
    lllllll = "vvvvvvvvv"
  },{
    treat_as_leaf = false,
    mode = "assoc",
    val = { "keystop", "valuestop" },
  }),
  {
    lll = { keystop = 5, valuestop = 5 },
    ll = { keystop = 6, valuestop = 3 },
    llllll = { keystop = 8, valuestop = 2 },
    lllllll = { keystop = 7, valuestop = 9 }
  }

)
assertMessage(
  flatten({
    l = {
      lll = "vvvvv",
      l = {
        ll = "vvv"
      }, 
      llllll = "vv"
    },
    lllllll = "vvvvvvvvv"
  },{
    treat_as_leaf = false,
    mode = "assoc",
    val = { "keystop", "valuestop" },
    indentation = 3,
  }),
  {
    lll = { keystop = 6, valuestop = 5 },
    ll = { keystop = 8, valuestop = 3 },
    llllll = { keystop = 9, valuestop = 2 },
    lllllll = { keystop = 7, valuestop = 9 }
  }
)