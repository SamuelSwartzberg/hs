
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

---@param a? any
---@param crement? "in" | "de"
---@return any
function crementIfNumber(a, crement)
  a = a or 0
  crement = crement or "in"
  if type(a) == "number" then
    if crement == "in" then
      return a + 1
    elseif crement == "de" then
      return a - 1
    else
      error("Invalid crement: " .. crement)
    end
  else
    return a
  end
end

---@param a any
---@return boolean
function isEven(a)
  return a % 2 == 0
end