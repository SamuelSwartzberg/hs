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

