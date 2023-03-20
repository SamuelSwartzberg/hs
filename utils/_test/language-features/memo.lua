-- a poisonable will run once just fine, but will error if called again
-- thus it can be used to test that a function is only called once
-- which is useful to test memoization

local poisonable1 = returnPoisonable()

assertMessage(
  memoize(poisonable1)(1, 2, 3),
  {1, 2, 3}
)

assertMessage(
  memoize(poisonable1)(1, 2, 3),
  {1, 2, 3}
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
  })(1, 2, 3),
  {1, 2, 3}
)

assertMessage(
  memoize(poisonable3, {
    mode = "fs"
  })(1, 2, 3),
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

hs.timer.usleep(1001)

local succ, res = pcall(
  memoize(poisonable4, {
    mode = "mem",
    invalidation_mode = "invalidate",
  }),
  1, 2, 3
)

assertMessage(succ, false)

assertMessage(res, "poisoned")

local poisonable5 = returnPoisonable()

local memoizedPoisonable5, timer = memoize(poisonable5, {
  mode = "mem",
  invalidation_mode = "reset",
  interval = 1
})

assertMessage(
  memoizedPoisonable5(1, 2, 3),
  {1, 2, 3}
)

hs.timer.usleep(500)

assertMessage(
  memoizedPoisonable5(1, 2, 3),
  {1, 2, 3}
)

hs.timer.usleep(501)

local succ, res = pcall(
  memoizedPoisonable5,
  1, 2, 3
)

assertMessage(succ, false)
assertMessage(res, "poisoned")
assertMessage(timer ~= nil, true)

timer:stop()