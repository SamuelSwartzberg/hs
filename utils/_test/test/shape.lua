
local shape1 = {
  ["[string]"] = "function"
}

local shape2 = get.table.copy(shape1)
local shape3 = get.table.copy(shape1)

local thing1 = {
  foo = function() end
}

local thing2 = {
  foo = function() end,
  bar = function() end
}

local thing3 = {
  foo = function() end,
  bar = function() end,
  [2] = "rawr"
}

resolveTypeMatchingToKeys(thing1, shape1)
resolveTypeMatchingToKeys(thing2, shape2)
resolveTypeMatchingToKeys(thing3, shape3)


assertMessage(
  shape1,
  {
    foo = "function"
  }
)

assertMessage(
  shape2,
  {
    foo = "function",
    bar = "function"
  }
)

assertMessage(
  shape3,
  {
    foo = "function",
    bar = "function",
  }
)

local shape4 = {
  ["[string]"] = "string",
  ["[number]"] = "number"
}

local shape5 = get.table.copy(shape4)
local shape6 = get.table.copy(shape4)

local thing4 = {
  foo = "bar",
  [2] = "baz"
}

local thing5 = {
  [2] = "baz",
  [3] = 2,
}

local thing6 = {
  foo = "bar",
  [2] = "baz",
  [false] = "reee"
}

resolveTypeMatchingToKeys(thing4, shape4)
resolveTypeMatchingToKeys(thing5, shape5)
resolveTypeMatchingToKeys(thing6, shape6)

assertMessage(
  shape4,
  {
    foo = "string",
    [2] = "number"
  }
)

assertMessage(
  shape5,
  {
    [2] = "number",
    [3] = "number"
  }
)

assertMessage(
  shape6,
  {
    foo = "string",
    [2] = "number",
  }
)

local shape7 = {
  ["[string]"] = "string",
  ["[number]"] = "number",
  foo = "boolean"
}

local shape8 = get.table.copy(shape7)

local thing7 = {
  foo = "bar",
  [2] = 2,
  quux = "string"
}

local thing8 = {
  [2] = "lalala",
}

resolveTypeMatchingToKeys(thing7, shape7)
resolveTypeMatchingToKeys(thing8, shape8)

assertMessage(
  shape7,
  {
    foo = "boolean",
    [2] = "number",
    quux = "string"
  }
)

assertMessage(
  shape8,
  {
    [2] = "number",
    foo = "boolean"
  }
)

-- shapeMatchesInner

-- Must pass: simple key, simple value, is present, correct type
assert(
  shapeMatchesInner(
    {
      user = "Lucy"
    },
    {
      user = "string"
    },
    "User1"
  )
)

-- Must fail: simple key, simple value, is present, incorrect type

local succ, res = pcall(
  shapeMatchesInner,
  {
    user = "Lucy"
  },
  {
    user = "number"
  },
  "User1"

)

assert(not succ)
assertMessage(
  res,
  "Key user in User1 is not of type number, but instead of type string"
)

-- Must fail: simple key, simple value, is not present

local succ, res = pcall(
  shapeMatchesInner,
  {
  },
  {
    user = "number"
  },
  "User1"
)

assert(not succ)
assertMessage(
  res,
  "Key user in User1 is missing"
)

-- Must fail: simple key, simple value, is present (but not in shape)

local succ, res = pcall(
  shapeMatchesInner,
  {
    gender = "agender"
  },
  {
  },
  "User1"
)

assert(not succ)
assertMessage(
  res,
  "Key gender is in User1 but not in shape"
)

-- Must succeed: optional key, simple value, is present, correct type

assert(
  shapeMatchesInner(
    {
      gender = "agender"
    },
    {
      ["gender?"] = "string"
    },
    "User1"
  )
)

-- Must succeed: optional key, simple value, is not present

assert(
  shapeMatchesInner(
    {
    },
    {
      ["gender?"] = "string"
    },
    "User1"
  )
)

-- Must succeed: type key, simple value, is present, correct type

assert(
  shapeMatchesInner(
    {
      ["foo"] = "aceflux"
    },
    {
      ["[string]"] = "string"
    },
    "User1"
  )
)

-- Must fail: type key, simple value, is present, incorrect type

local succ, res = pcall(
  shapeMatchesInner,
  {
    ["foo"] = "aceflux"
  },
  {
    ["[string]"] = "number"
  },
  "User1"
)

assert(not succ)
assertMessage(
  res,
  "Key foo in User1 is not of type number, but instead of type string"
)

-- Must succeed: type key, simple value, is not present

assert(
  shapeMatchesInner(
    {
  },
    {
    ["[string]"] = "string"
  },
  "User1"
  )
)

-- Must succeed: simple key, object value, is present, correct type

assert(
  shapeMatchesInner(
    {
      child = {
        name = "Lucy"
      }
    },
    {
      child = {
        name = "string"
      }
    },
    "User1"
  )
)

-- Must fail: simple key, object value, is present, incorrect type

local succ, res = pcall(
  shapeMatchesInner,
  {
    child = {
      name = "Lucy"
    }
  },
  {
    child = {
      name = "number"
    }
  },
  "User1"
)

assert(not succ)
assertMessage(
  res,
  "Key name in User1.child is not of type number, but instead of type string"
)

-- Must fail: simple key, object value, is not present

local succ, res = pcall(
  shapeMatchesInner,
  {
  },
  {
    child = {
      name = "number"
    }
  },
  "User1"
)

assert(not succ)
assertMessage(
  res,
  "Key child in User1 is missing"
)

-- Must fail: simple key, object value, child key is not present

local succ, res = pcall(
  shapeMatchesInner,
  {
    child = {
    }
  },
  {
    child = {
      name = "number"
    }
  },
  "User1"
)

assert(not succ)
assertMessage(
  res,
  "Key name in User1.child is missing"
)

-- Must fail: simple key, object value, child key is present but not in shape

local succ, res = pcall(
  shapeMatchesInner,
  {
    child = {
      name = "Cryofreeze"
    }
  },
  {
    child = {
      
    }
  },
  "User1"
)

assert(not succ)
assertMessage(
  res,
  "Key name is in User1.child but not in shape"
)

-- Must succeed: optional key, object value, child key: is present, correct type

assert(
  shapeMatchesInner(
    {
      child = {
        name = "Lucy"
      }
    },
    {
      child = {
        ["name?"] = "string"
      }
    },
    "User1"
  )
)

-- Must succeed: optional key, object value, child key: is not present

assert(
  shapeMatchesInner(
    {
      child = {
      }
    },
    {
      child = {
        ["name?"] = "string"
      }
    },
    "User1"
  )
)

-- Must succeed: two optional keys, object value, child key: is not present

assert(
  shapeMatchesInner(
    {
      child = {
      }
    },
    {
      child = {
        ["name?"] = "string",
        ["age?"] = "number"
      }
    },
    "User1"
  )
)

-- Must succeed: type key, object value, child key: is present, also an object value

assert(
  shapeMatchesInner(
    {
      child = {
        name = {
          first = "Lucy",
          last = "Cryofreeze"
        }
      }
    },
    {
      child = {
        ["name?"] = {
          first = "string",
          last = "string"
        }
      }
    },
    "User1"
))

assert(
  shapeMatchesInner(
    {
      name = "foo",
      zebra = "bar"
    },
    {
      ["name?"] = "string",
      ["zebra?"] = "string"
    },
    "User1"
  )
)

assert(
  shapeMatchesInner(
    {
      name = {},
      zebra = {}
    },
    {
      ["name?"] = {
        ["[string]"] = "string"
      },
      ["zebra?"] = {
        ["[string]"] = "string"
      }
    },
    "User1"
  )
)

assert(
  shapeMatchesInner(
    {
      child = {
        name = {
          first = "Lucy",
          last = "Cryofreeze"
        },
        zebras = {
          
        }
      }
    },
    {
      child = {
        ["name?"] = {
          first = "string",
          last = "string"
        },
        ["zebras?"] = {
          ["[string]"] = "string"
        }
      }
    },
    "User1"
))

assert(
  shapeMatchesInner(
    {
      child = {
        name = {
          first = "Lucy",
          last = "Cryofreeze"
        }
      }
    },
    {
      child = {
        ["name?"] = {
          ['[string]'] = "string",
        }
      }
    },
    "User1"
))

-- Must fail: type key, object value, child key: is present, incorrect type

local succ, res = pcall(
  shapeMatchesInner,
  {
    child = {
      name = "Lucy"
    }
  },
  {
    child = {
      ["[string]"] = "number"
    }
  },
  "User1"
)

assert(not succ)
assertMessage(
  res,
  "Key name in User1.child is not of type number, but instead of type string"
)