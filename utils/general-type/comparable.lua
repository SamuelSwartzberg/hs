--- @alias comparable_implementation {__eq: fun(self: any, other: any): (boolean), __lt: fun(self: any, other: any): (boolean), __le: fun(self: any, other: any): (boolean)}
--- @alias comparable comparable_implementation | number | string -- presumably comparison is implemented via metamethods for numbers and strings as well, but my annotation system doesn't expose that

--- @generic T : comparable
--- @param val T
--- @param min T
--- @param max T
--- @return T
function clamp(val, min, max)
  if val < min then
    return min
  elseif val > max then
    return max
  else
    return val
  end
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