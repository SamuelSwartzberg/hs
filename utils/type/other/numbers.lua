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
--- @param target? "upper" | "lower" | "center"
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

--- @alias randSpec { low?: number, high?: number, len?: number }

--- @type fun(spec?: randSpec, type?: "int"): (integer) | fun(spec?: randSpec, type?: "number"): (number) | fun(spec?: randSpec, type?: "b64"): (string)
function rand(spec, type)
  spec = spec or {}

  -- simple default logic: if we pass len or if both high or low (if set) are ints, then we return an int, otherwise a number (float). This should allow for intuitive usage.
  if 
    spec.len or
    (
      (not spec.low or isNumber(spec.low, "int")) and
      (not spec.high or isNumber(spec.high, "int"))
    )
  then
    type = type or "int"
  else
    type = type or "number"
  end

  local low, high = spec.low, spec.high

  -- handle len case
  if spec.len then
    low = intOfLength(spec.len, "lower")
    high = intOfLength(spec.len, "upper")
  end

  -- set defaults for low and high
  if not low then
    low = 0
  end
  if not high then
    high = 1
  end
  local randnr = low + math.random()  * (high - low);
  if type == "int" then
    return toNumber(randnr, "int", "error")
  elseif type == "number" then
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

--- @param thing any The thing to convert.
--- @param target? "number" | "int" | "pos-int" What to convert to. Defaults to "number".
--- @param mode? "error" | "nil" | "invalid-number" What to do if the value cannot be converted to the target type. Defaults to "nil".
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
    if mode == "error" then
      error("Value cannot be converted to a " .. target .. ": " .. tostring(thing))
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