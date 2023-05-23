-- a poisonable will run once just fine, but will error if called again
-- thus it can be used to test that a function is only called once
-- which is useful to test memoization

local realenv = env
env = {
  XDG_CACHE_HOME = "/Users/sam/.cache",
  HOME = "/Users/sam"
}

local poisonable1 = returnPoisonable()

assertMessage(
  memoize(poisonable1)(1, 2, 3),
  {1, 2, 3}
)

assertMessage(
  memoize(poisonable1)(1, 2, 3),
  {1, 2, 3}
)

local succ, res = pcall(poisonable1, 1, 2, 3)

assertMessage(
  succ,
  false
)

local poisonable2 = returnPoisonable()

assertMessage(
  memoize(poisonable2, {
    mode = "mem"
  })(1, 2, 3),
  {1, 2, 3}
)

assertMessage(
  memoize(poisonable2, {
    mode = "mem"
  })(1, 2, 3),
  {1, 2, 3}
)
local poisonable3 = returnPoisonable()

assertMessage(
  memoize(poisonable3, {
    mode = "fs"
  }, "poisonable3")(1, 2, 3),
  {1, 2, 3}
)

assertMessage(
  memoize(poisonable3, {
    mode = "fs"
  }, "poisonable3")(1, 2, 3),
  {1, 2, 3}
)

local async_poisoned = false
local function asyncPoisonable(arg, callback)
  if async_poisoned then
    error("poisoned")
  end
  async_poisoned = true
  callback(arg)
end

local async_poisonable_memoized = memoize(asyncPoisonable, {
  is_async = true
})

async_poisonable_memoized(1, function(result)
  assertMessage(result, 1)
end)

async_poisonable_memoized(1, function(result)
  assertMessage(result, 1)
end)

local poisonable4 = returnPoisonable()

assertMessage(
  memoize(poisonable4, {
    mode = "mem",
    invalidation_mode = "invalidate",
    interval = 1
  })(1, 2, 3),
  {1, 2, 3}
)

hs.timer.usleep(1050 * 1000)

local succ, res = pcall(
  memoize(poisonable4, {
    mode = "mem",
    invalidation_mode = "invalidate",
    interval = 1
  }),
  1, 2, 3
)

assertMessage(succ, false)

local poisonable5 = returnPoisonable()

local memoizedPoisonable5, timer = memoize(poisonable5, {
  mode = "mem",
  invalidation_mode = "reset",
  interval = 2
})

assertMessage(
  memoizedPoisonable5(1, 2, 3),
  {1, 2, 3}
)

hs.timer.doAfter(1, function()
  assertMessage(
    memoizedPoisonable5(1, 2, 3),
    {1, 2, 3}
  )
  hs.timer.doAfter(2, function()
    local succ, res = pcall(
      memoizedPoisonable5,
      1, 2, 3
    )
    
    assertMessage(succ, false)
    assertMessage(timer ~= nil, true)
    timer:stop()
    env = realenv
  end)
end)


local poisonable6 = returnPoisonable()

local memoizedPoisonable6 = memoize(poisonable6, {stringify_table_params = true})

assertMessage(
  memoizedPoisonable6({"foo", "bar"}),
  {{"foo", "bar"}}
)

assertMessage(
  memoizedPoisonable6({"foo", "bar"}),
  {{"foo", "bar"}}
)

local succ, res = pcall(
  poisonable6,
  {"foo", "bar"}
)

assertMessage(succ, false)

local poisonable7 = returnPoisonable()

local memoizedPoisonable7 = memoize(poisonable7,  {stringify_table_params = true})

assertMessage(
  memoizedPoisonable7({"foo", "bar"}, {"baz"}),
  { {"foo", "bar"}, {"baz"} }
)

assertMessage(
  memoizedPoisonable7({"foo", "bar"}, {"baz"}),
  { {"foo", "bar"}, {"baz"} }
)

local succ, res = pcall(
  poisonable7,
  {"foo", "bar"}, {"baz"}
)

assertMessage(succ, false)

local poisonable8 = returnPoisonable()

local memoizedPoisonable8 = memoize(poisonable8, {stringify_table_params = true, table_param_subset = "no-fn-userdata-loops"})

local bigtbl = {
  baz = "qux",
  love = {
    "is",
    "all",
    "you",
  },
  need   = {
    [true] = "!"
  }
}

assertMessage(
  memoizedPoisonable8(
    {
      foo = "bar"
    },
    bigtbl
  ),
  {
    {
      foo = "bar"
    },
    bigtbl
  }
)

assertMessage(
  memoizedPoisonable8(
    {
      foo = "bar"
    },
    bigtbl
  ),
  {
    {
      foo = "bar"
    },
    bigtbl
  }
)

local succ, res = pcall(
  poisonable8,
  {
    foo = "bar"
  },
  bigtbl
)

assertMessage(succ, false)

--- test that memoizing tables as args always works.

--- shallow table
  
local poisonable9_1 = returnPoisonable()
local poisonable9_2 = returnPoisonable()
local poisonable9_3 = returnPoisonable()

local tbl_w_keys = {
  a = "a",
  b = "b",
  c = "c",
  d = "d",
  e = "e",
}

local memoizedPoisonable9_1 = memoize(poisonable9_1, refstore.params.memoize.opts.stringify_json)

local memoizedPoisonable9_2 = memoize(poisonable9_2, {stringify_table_params = true, table_param_subset = "no-fn-userdata-loops"})

local memoizedPoisonable9_3 = memoize(poisonable9_3, {stringify_table_params = true, table_param_subset = "any"})

--- 100 iters to make sure that the order of the keys is not just a fluke

for i = 1, 100 do
  assertMessage(
    memoizedPoisonable9_1(
      tbl_w_keys
    ),
    {tbl_w_keys}
  )
  
  assertMessage(
    memoizedPoisonable9_2(
      tbl_w_keys
    ),
    {tbl_w_keys}
  )
  
  assertMessage(
    memoizedPoisonable9_3(
      tbl_w_keys
    ),
    {tbl_w_keys}
  )
end

--- nested table

local poisonable10_1 = returnPoisonable()
local poisonable10_2 = returnPoisonable()
local poisonable10_3 = returnPoisonable()

local tbl_w_keys = {
  a = "a",
  b = "b",
  c = "c",
  d = "d",
  e = "e",
  f = {
    a = "a",
    b = "b",
    c = "c",
    d = "d",
    e = "e",
  }
}

local memoizedPoisonable10_1 = memoize(poisonable10_1, refstore.params.memoize.opts.stringify_json)
local memoizedPoisonable10_2 = memoize(poisonable10_2, {stringify_table_params = true, table_param_subset = "no-fn-userdata-loops"})
local memoizedPoisonable10_3 = memoize(poisonable10_3, {stringify_table_params = true, table_param_subset = "any"})

--- 100 iters to make sure that the order of the keys is not just a fluke

for i = 1, 100 do
  assertMessage(
    memoizedPoisonable10_1(
      tbl_w_keys
    ),
    {tbl_w_keys}
  )
  
  assertMessage(
    memoizedPoisonable10_2(
      tbl_w_keys
    ),
    {tbl_w_keys}
  )
  
  assertMessage(
    memoizedPoisonable10_3(
      tbl_w_keys
    ),
    {tbl_w_keys}
  )
end

--- numerical values

local poisonable11_1 = returnPoisonable()
local poisonable11_2 = returnPoisonable()
local poisonable11_3 = returnPoisonable()

local tbl_w_keys = {
  a = 1,
  b = 2,
  c = 3,
  d = 4,
  e = 5,
}

local memoizedPoisonable11_1 = memoize(poisonable11_1, refstore.params.memoize.opts.stringify_json)
local memoizedPoisonable11_2 = memoize(poisonable11_2, {stringify_table_params = true, table_param_subset = "no-fn-userdata-loops"})
local memoizedPoisonable11_3 = memoize(poisonable11_3, {stringify_table_params = true, table_param_subset = "any"})

--- 100 iters to make sure that the order of the keys is not just a fluke

for i = 1, 100 do
  assertMessage(
    memoizedPoisonable11_1(
      tbl_w_keys
    ),
    {tbl_w_keys}
  )
  
  assertMessage(
    memoizedPoisonable11_2(
      tbl_w_keys
    ),
    {tbl_w_keys}
  )
  
  assertMessage(
    memoizedPoisonable11_3(
      tbl_w_keys
    ),
    {tbl_w_keys}
  )
end

--- function values ("any" only)

local poisonable12_1 = returnPoisonable()

local tbl_w_keys = {
  a = function() end,
  b = function() end,
  c = function() end,
  d = function() end,
  e = function() end,
}

local memoizedPoisonable12_1 = memoize(poisonable12_1, {stringify_table_params = true, table_param_subset = "any"})

--- 100 iters to make sure that the order of the keys is not just a fluke

for i = 1, 100 do
  assertMessage(
    memoizedPoisonable12_1(
      tbl_w_keys
    ),
    {tbl_w_keys}
  )
end

--- nested function values ("any" only)

local poisonable13_1 = returnPoisonable()

local tbl_w_keys = {
  a = function() end,
  b = function() end,
  c = function() end,
  d = function() end,
  e = function() end,
  f = {
    a = function() end,
    b = function() end,
    c = function() end,
    d = function() end,
    e = function() end,
  }
}

local memoizedPoisonable13_1 = memoize(poisonable13_1, {stringify_table_params = true, table_param_subset = "any"})

--- 100 iters to make sure that the order of the keys is not just a fluke

for i = 1, 100 do
  assertMessage(
    memoizedPoisonable13_1(
      tbl_w_keys
    ),
    {tbl_w_keys}
  )
end

--- self-referential table ("any" only)

local poisonable14_1 = returnPoisonable()

local tbl_w_keys = {
  a = "a",
  b = "b",
  c = "c",
  d = "d",
  e = "e",
  nested = {
    a = "a",
    b = "b",
    c = "c",
    d = "d",
    e = "e",
  }
}

tbl_w_keys.nested.self = tbl_w_keys

local memoizedPoisonable14_1 = memoize(poisonable14_1, {stringify_table_params = true, table_param_subset = "any"})

--- 100 iters to make sure that the order of the keys is not just a fluke

for i = 1, 100 do
  assertMessage(
    memoizedPoisonable14_1(
      tbl_w_keys
    ),
    {tbl_w_keys}
  )
end

-- mutate result of memoized function, make sure that it doesn't affect the cache

local example_table = {
  a = "a",
  b = "b",
}

local test_table_1 = copy(example_table)
local test_table_2 = copy(example_table)
local test_table_3 = copy(example_table)

local res1 = memoize(
  returnSame,
  refstore.params.memoize.opts.stringify_json
)(
  test_table_1
)

assertMessage(
  res1,
  example_table
)

-- try and mutate the result from the uncached result table

res1.c = "c"

local res2 = memoize(
  returnSame,
  refstore.params.memoize.opts.stringify_json
)(
  test_table_2
)

assertMessage(
  res2,
  example_table
)

-- mutate the result from the cached result table

res2.c = "c"

local res3 = memoize(
  returnSame,
  refstore.params.memoize.opts.stringify_json
)(
  test_table_3
)

assertMessage(
  res3,
  example_table
)


-- purge cache for single function (mem)

local poisonable15 = returnPoisonable()

assertMessage(
  memoize(poisonable15)(1, 2, 3),
  {1, 2, 3}
)

assertMessage(
  memoize(poisonable15)(1, 2, 3),
  {1, 2, 3}
)

purgeCache(poisonable15, "mem")

-- since the cache was purged, it should be empty, forcing us to recompute the result, thus poisoning it

local succ, res = pcall(memoize(poisonable15), 1, 2, 3)

assert(not succ)

-- purge cache for single function (fs)

local poisonable16 = returnPoisonable()

assertMessage(
  memoize(poisonable16, {mode = "fs"}, "poisonable16")(1, 2, 3),
  {1, 2, 3}
)

assertMessage(
  memoize(poisonable16, {mode = "fs"},  "poisonable16")(1, 2, 3),
  {1, 2, 3}
)

purgeCache("poisonable16", "fs")

-- since the cache was purged, it should be empty, forcing us to recompute the result, thus poisoning it

local succ, res = pcall(memoize(poisonable16, {mode = "fs"}, "poisonable16"), 1, 2, 3)

assert(not succ)

-- purge cache for all functions (mem)

purgeCache(nil, "mem")

local succ, res = pcall(memoize(poisonable2, {
  mode = "mem"
}), 1, 2, 3)

assert(not succ)

-- purge cache for all functions (fs)

purgeCache(nil, "fs")

local succ, res = pcall(memoize(poisonable3, {
  mode = "fs"
}, "poisonable3"), 1, 2, 3)

assert(not succ)