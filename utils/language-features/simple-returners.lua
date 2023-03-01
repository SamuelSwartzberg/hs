--- @return true
function returnTrue()
  return true
end

--- @return false
function returnFalse()
  return false
end

--- @param b any
--- @return boolean
function returnNot(b)
  return not b
end

--- @param b any
--- @return boolean
function returnBool(b)
  return not not b
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

--- @param a any
--- @param b any
--- @return boolean
function returnEqual(a, b)
  return a == b
end

--- @param a any
--- @param b any
--- @return boolean
function returnLarger(a, b)
  return a > b
end

--- @param a any
--- @param b any
--- @return boolean
function returnSmaller(a, b)
  return a < b
end

--- @generic T
--- @param list T[]
--- @return T
function returnLast(list)
  return list[#list]
end