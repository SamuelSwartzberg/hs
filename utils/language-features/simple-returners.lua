--- @return true
function returnTrue()
  return true
end

--- @return false
function returnFalse()
  return false
end

--- @return nil
function returnNil()
  return nil
end

--- @return ""
function returnEmptyString()
  return ""
end

--- @return {}
function returnEmptyTable()
  return {}
end

--- @return 0
function returnZero()
  return 0
end

--- @return 1
function returnOne()
  return 1
end

--- @generic T
--- @param value T
--- @return T
function returnSame(value)
  return value
end

function returnAny(...)
  return ...
end

--- @generic T
--- @param value T
--- @param n integer
--- @return ...
function returnSameNTimes(value, n)
  local result = {}
  for i = 1, n do
    result[i] = value
  end
  return table.unpack(result)
end

--- @param ... any
--- @return integer
function returnNumArgs(...)
  local args = {...}
  return #args
end