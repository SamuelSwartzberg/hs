
assertMessage(
  listSort(
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
  )),
  { 1, 2, 3, 4 }
)

assertMessage(
  listSort(flatten(
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
  )),
  { 1, 2, 3, 4, 5 }
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
    treat_as_leaf = "list",
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
