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
  mergeAssocArrRecursive(
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
  nestedAssocArrToListIncludingPath(
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
    {}
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
  nestedAssocArrToListIncludingPathAndDepth(
    {
      a = {
        b = {
          c = 1,
          d = 2
        },
        e = 3
      },
      f = 4
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
  nestedAssocArrToFlatPathAssocArrWithDotNotation(
    {
      a = {
        b = {
          c = 1,
          d = 2
        },
        e = 3
      },
      f = 4
    }
  ),
  {
    ["a.b.c"] = 1,
    ["a.b.d"] = 2,
    ["a.e"] = 3,
    ["f"] = 4
  }
)

assertTable(
  mergeAssocArrRecursive(
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
  nestedAssocArrGetStopsForKeyValue({
    l = {
      lll = "vvvvv",
      l = {
        ll = "vvv"
      }, 
      llllll = "vv"
    },
    lllllll = "vvvvvvvvv"
  }, 2),
  {
    lll = { key_stop = 5, value_stop = 5 },
    ll = { key_stop = 6, value_stop = 3 },
    llllll = { key_stop = 8, value_stop = 2 },
    lllllll = { key_stop = 7, value_stop = 9 }
  }

)

assertTable(
  {nestedAssocArrGetMaxStops({
    l = {
      lll = "vvvvv",
      l = {
        ll = "vvv"
      }, 
      llllll = "vv"
    },
    lllllll = "vvvvvvvvv"
  }, 2)},
  {
    8, 9
  }
)

assertTable(
  mapTableWithValueInCertainKeyToTableHoldingValueDirectly(
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
    "value",
    false,
    false
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
  mapTableWithValueInCertainKeyToTableHoldingValueDirectly(
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
    }
  , "value", true, true),
  {
    a = "foo",
    c = {
      h = {
        i = "blue",
      }
    },
  }
)