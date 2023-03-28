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
--[[ 
local poisonable3 = returnPoisonable()

assertMessage(
  memoize(poisonable3, {
    mode = "fs"
  })(1, 2, 3),
  {1, 2, 3}
)

assertMessage(
  memoize(poisonable3, {
    mode = "fs"
  })(1, 2, 3),
  {1, 2, 3}
) ]] -- TODO: re-enable this test once `run` (which is a hidden dependency of `memoize` mode = "fs") is implemented

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





