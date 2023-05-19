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

--- @generic T, U
--- @param a T
--- @param b U
--- @return T | U
function returnLargerItem(a, b)
  if a > b then
    return a
  else
    return b
  end
end

--- @param a any
--- @param b any
--- @return boolean
function returnSmaller(a, b)
  return a < b
end

--- @param a number
--- @return number
function returnAdd1(a)
  return a + 1
end

--- @generic T
--- @param list T[]
--- @return T
function returnLast(list)
  return list[#list]
end

--- @generic T : string | any[]
--- @param thing T
--- @return T
function returnEmpty(thing)
  if type(thing) == "string" then
    return ""
  else
    return {}
  end
end

--- @param a any
--- @param b any
--- @return boolean
function returnAnd(a, b)
  return a and b
end

--- @param a any
--- @param b any
--- @return boolean
function returnOr(a, b)
  return a or b
end

--- @generic T
--- @param a T
--- @param b T
--- @return T
function returnSum(a, b)
  return a + b
end

--- @param regex string
--- @return string
function whole(regex)
  return "^" .. regex .. "$"
end

--- @generic T
--- @param arg T[]
--- @return ...T
function returnUnpack(arg)
  return table.unpack(arg)
end

--- @generic T
--- @param ... T
--- @return T[]
function returnPack(...)
  return {...}
end

--- @generic T 
--- @param potential_tbl primitive | T[]
--- @return primitive | ...<T>
function returnUnpackIfTable(potential_tbl)
  if type(potential_tbl) == "table" then
    return table.unpack(potential_tbl)
  else
    return potential_tbl
  end
end

function returnPoisonable()
  local dirty = false
  local returnfn
  returnfn = function(...)
    if dirty then
      error("poisoned " .. tostring(returnfn))
    end
    dirty = true
    return {...}
  end
  return returnfn
end

function returnStringEquivOrder(a, b)
  return tostring(a) < tostring(b)
end