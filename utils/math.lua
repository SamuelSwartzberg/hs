
---@param a integer
---@param b integer
---@param modulo integer
---@return integer
function additionRingModuloN(a, b, modulo)
    return (a + b) % modulo
end

---@param a integer
---@param b integer
---@param modulo integer
---@return integer
function subtractionRingModuloN(a, b, modulo)
  return (a - b) % modulo
end

---@param a number
---@param b number
---@param distance? number
---@return boolean
function isClose(a, b, distance)
  if not distance then distance = 1 end
  if a > b then
    return a - b < distance
  else
    return b - a < distance
  end
end

---@param a any
---@return any
function decrementIfNumber(a)
  if type(a) == "number" then
    return a - 1
  else
    return a
  end
end

---@param a any
---@return boolean
function isEven(a)
  return a % 2 == 0
end