--- @alias randSpec { low?: number, high?: number, len?: number }

--- @type fun(spec?: randSpec, type?: "int"): (integer) | fun(spec?: randSpec, type?: "number"): (number) | fun(spec?: randSpec, type?: "b64"): (string)
function rand(spec, type)
  spec = spec or {}

  -- simple default logic: if we pass len or if both high or low (if set) are ints, then we return an int, otherwise a number (float). This should allow for intuitive usage.
  if 
    spec.len or
    (
      (not spec.low or is.number.int(spec.low)) and
      (not spec.high or is.number.int(spec.high))
    )
  then
    type = type or "int"
  else
    type = type or "number"
  end

  local low, high = spec.low, spec.high

  -- handle len case
  if spec.len then
    low = transf.pos_int.smallest_int_of_length(spec.len)
    high = transf.pos_int.largest_int_of_length(spec.len)
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
    return get.string_or_number.int(randnr)
  elseif type == "number" then
    return randnr
  elseif type == "b64" then
    local len = transf.int.length(randnr)
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