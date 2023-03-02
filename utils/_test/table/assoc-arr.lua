assertTable(
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

assertTable(
  listWithChildrenKeyToListIncludingPath({
    {
      title = "a",
      children = {
        {
          title = "b",
          children = {
            {
              title = "c"
            }
          }
        },
        {
          title = "d"
        }
      }
    },
    {
      title = "e"
    }
  }),
  {
    {
      title = "c",
      path = {"a", "b"}
    },
    {
      title = "d",
      path = {"a"}
    },
    {
      title = "e",
      path = {}
    }
  }
)

assertTable(
  listWithChildrenKeyToListIncludingPath({
    {
      title = "a",
      children = {
        {
          title = "b",
          children = {
            {
              title = "c"
            }
          }
        },
        {
          title = "d"
        }
      }
    },
    {
      title = "e"
    }
  }, {}, {include_inner_nodes = true}),
  {
    {
      title = "a",
      path = {}
    },
    {
      title = "b",
      path = {"a"}
    },
    {
      title = "c",
      path = {"a", "b"}
    },
    {
      title = "d",
      path = {"a"}
    },
    {
      title = "e",
      path = {}
    }
  }
)



assertTable(
  listWithChildrenKeyToListIncludingPath({
    {
      addressation = "a",
      progeny = {
        {
          addressation = "b",
          progeny = {
            {
              addressation = "c"
            }
          }
        },
        {
          addressation = "d"
        }
      }
    }
  }, {}, { children_key_name = "progeny", title_key_name = "addressation"}),
  {
    {
      addressation = "c",
      path = {"a", "b"}
    },
    {
      addressation = "d",
      path = {"a"}
    },
  }
)

assertTable(
  listWithChildrenKeyToListIncludingPath({
    {
      title = "a",
      children = {
        {
          {
            title = "b",
            children = {
              {
                title = "c"
              }
            }
          }
        }
      }
    }
  }, {}, {levels_of_nesting_to_skip = 1}),
  {
    {
      title = "b",
      path = {"a"}
    }
  } -- note that the "c" is not included, because we skipped a level of nesting
)

assertTable(
  merge(
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
      foo = "roar",
      baz = "rrrr"
    }
  }
)

assertValuesContainExactly(
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
assertValuesContainExactly(
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
      val = { "path", "depth" },
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

assertTable(
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
    treat_as_leaf = "list",
  }),
  {
    ["a.b.c"] = 1,
    ["a.b.d"] = 2,
    ["a.e"] = 3,
    ["f"] = 4
  }
)

assertTable(
  merge(
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

assertTable(
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

assertTable(
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

assertTable(
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