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
--- @param mode? "num" | "int" | "pos-int" | "neg-int" | "float"
--- @return boolean
function isNumber(val, mode)
  mode = mode or "num"
  if type(val) == "number" then
    if math.floor(val) == val then -- is int
      if val > 0 then
        if mode == "neg-int" then
          return false
        else
          return true
        end
      elseif val < 0 then
        if mode == "pos-int" then
          return false
        else
          return true
        end
      else
        if mode == "pos-int" or mode == "neg-int" then
          return false
        else
          return true
        end
      end
    else
      if mode == "num" or mode == "float" then
        return true
      else 
        return false
      end
    end
  else
    return false
  end
end

--- @param val integer
--- @return integer
function lengthOfInt(val)
  if isNumber(val, "int") then
    return #tostring(val)
  else
    error("Value is not an integer")
  end
end

--- @param length integer
--- @param target "upper" | "lower" | "center"
--- @return integer
function intOfLength(length, target)
  target = target or "center"
  if length < 1 then
    error("Length must be at least 1")
  end
  local largest_plus_1 = math.floor(1 * 10 ^ length)
  if target == "upper" then
    return largest_plus_1 - 1
  elseif target == "lower" then
    return largest_plus_1 / 10
  elseif target == "center" then
    return largest_plus_1 / 2
  else
    error("Invalid target: " .. target)
  end
end

--- @param length integer
--- @return integer
function randomInt(length)
  return math.random(intOfLength(length, "lower"), intOfLength(length, "upper"))
end

--- @param spec { low?: number, high?: number, len?: number }
--- @param type? "number" | "b64"
--- @return number | string
function rand(spec, type)
  spec = spec or {}
  type = type or "number"
  local low, high = spec.low, spec.high
  if spec.len then
    low = intOfLength(spec.len, "lower")
    high = intOfLength(spec.len, "upper")
  end
  local randnr = low + math.random()  * (high - low);
  if type == "number" then
    return randnr
  elseif type == "b64" then
    local len = lengthOfInt(randnr)
    return run({
      "openssl",
      "rand",
      "-base64",
      tostring(len)
    })
  else
    error("Invalid type: " .. type)
  end
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

  if (start > stop and step > 0) or (start < stop and step < 0) then -- these would cause an infinite loop
    return res
  end

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