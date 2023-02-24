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
--- @param mode_if_not_positive_number? "fail" | "nil" | "-1"
--- @return integer | nil
function toPosInt(val, mode_if_not_positive_number)
  mode_if_not_positive_number = mode_if_not_positive_number or "-1"
  if type(val) == "number" and val >= 0 then
    return math.floor(tonumber(val) + 0.5)
  else
    if mode_if_not_positive_number == "fail" then
      error("Value is not a positive number")
    elseif mode_if_not_positive_number == "nil" then
      return nil
    elseif mode_if_not_positive_number == "-1" then
      return -1
    else 
      error("Invalid mode_if_not_positive_number: " .. mode_if_not_positive_number)
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

--- @param length integer
--- @return integer
function smallestIntOfLength(length)
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


--- @return string
function longBase64RandomString()
  local res = getOutputTask({
    "openssl",
    "rand",
    "-base64",
    200
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