--- @param val any
--- @param mode_if_not_number? "fail" | "nil" | "0"
--- @return integer | nil
function toInt(val, mode_if_not_number)
  mode_if_not_number = mode_if_not_number or "0"
  if type(val) == "number" then
    return math.floor(tonumber(val) + 0.5)
  else
    if mode_if_not_number == "fail" then
      error("Value is not a number")
    elseif mode_if_not_number == "nil" then
      return nil
    elseif mode_if_not_number == "0" then
      return 0
    else 
      error("Invalid mode_if_not_number: " .. mode_if_not_number)
    end
  end
end

--- @param val any
--- @return boolean
function isInt(val)
  if type(val) == "number" then
    return math.floor(val) == val
  else
    return false
  end
end

--- @param val any
--- @return boolean
function isNegInt(val)
  if type(val) == "number" then
    return math.floor(val) == val and val < 0
  else
    return false
  end
end

--- @param val any
--- @return boolean
function isFloat(val)
  if type(val) == "number" then
    return math.floor(val) ~= val
  else
    return false
  end
end

--- @param val integer
--- @return integer
function lengthOfInt(val)
  if isInt(val) then
    return #tostring(val)
  else
    error("Value is not an integer")
  end
end

--- @param length integer
--- @return integer
function smallestIntOfLength(length)
  if length < 1 then
    error("Length must be at least 1")
  end
  return math.floor(1 * 10 ^ (length-1))
end

--- @param length integer
--- @return integer
function largestIntOfLength(length)
  return smallestIntOfLength(length + 1) - 1
end

--- @param length integer
--- @return integer
function randomInt(length)
  return math.random(smallestIntOfLength(length), largestIntOfLength(length))
end


--- @param length? integer
--- @return string
function base64RandomString(length)
  length = defaultIfNil(length, 200)
  local res = run({
    "openssl",
    "rand",
    "-base64",
    tostring(length)
  })
  return res
end

--- @param lower number
--- @param upper number
--- @return number
function randBetween(lower, upper)
  return lower + math.random()  * (upper - lower);
end

--- @param start? number
--- @param stop? number
--- @param step? number
--- @return number[]
function seq(start, stop, step)
  start = defaultIfNil(start, 1)
  stop = defaultIfNil(stop, 10)
  step = defaultIfNil(step, 1)

  local res = {}

  for i = start, stop, step do
    table.insert(res, i)
  end

  return res
end

--- @param thing any
--- @param target? "number" | "int" | "pos-int"
--- @param mode? "fail" | "nil" | "invalid-number"
--- @return number | nil
function toNumber(thing, target, mode)
  target = target or "number"
  mode = mode or "nil"
  local conv_func
  if target == "number" then
    conv_func = tonumber
  elseif target == "int" then
    conv_func = function(t)
      local t = tonumber(t)
      if not t then return nil end
      return math.floor(tonumber(t) + 0.5)
    end
  elseif target == "pos-int" then
    conv_func = function(t)
      local t = tonumber(t)
      if not t or t < 0 then return nil end
      return math.floor(tonumber(t) + 0.5)
    end
  else
    error("Invalid target: " .. target)
  end

  local res = conv_func(thing)

  if res == nil then
    if mode == "fail" then
      error("Value cannot be converted to a " .. target)
    elseif mode == "nil" then
      return nil
    elseif mode == "invalid-number" then
      return -math.huge
    else
      error("Invalid mode: " .. mode)
    end
  else
    return res
  end
end