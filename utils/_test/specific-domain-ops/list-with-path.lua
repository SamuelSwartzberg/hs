
assertMessage(
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

assertMessage(
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



assertMessage(
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

assertMessage(
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
