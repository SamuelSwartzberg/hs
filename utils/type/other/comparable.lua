--- @alias comparable_implementation {__eq: fun(self: any, other: any): (boolean), __lt: fun(self: any, other: any): (boolean), __le: fun(self: any, other: any): (boolean)}
--- @alias comparable comparable_implementation | number | string | hs_geometry_point_like -- presumably comparison is implemented via metamethods for numbers and strings as well, but my annotation system doesn't expose that

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

--- @generic T : comparable
---@param a T
---@param b T
---@param distance? T
---@return boolean
function isClose(a, b, distance)
  if not distance then distance = 1 end
  if a > b then
    return a - b < distance
  else
    return b - a < distance
  end
end

--- @generic T : comparable
--- @param start? T
--- @param stop? T
--- @param step? T
--- @param unit? any only required for some types
--- @return T[]
function seq(start, stop, step, unit)
  start = defaultIfNil(start, 1)

  local mode
  if type(start) == "number" then
    mode = "number"
  elseif type(start) == "table" then
    if start.addays then
      mode = "date"
    elseif start.xy then
      mode = "point"
    end
  elseif type(start) == "string" then
    mode = "string"
  end

  local addmethod = function(a, b) return a + b end

  if mode == "number" then
    stop = defaultIfNil(stop, 10)
    step = defaultIfNil(step, 1)
  elseif mode == "date" then
    if start then start = start:copy() else start = date() end
    if stop then stop = stop:copy() else stop = date():addays(10) end
    step = defaultIfNil(step, 1)
    unit = defaultIfNil(unit, "days")
    addmethod = function(a, b) 
      local a_copy = a:copy()
      return a_copy["add" .. unit](a_copy, b) 
    end
  elseif mode == "point" then
    start = defaultIfNil(start, hs.geometry.point(0, 0))
    stop = defaultIfNil(stop, hs.geometry.point(10, 10))
    step = defaultIfNil(step, hs.geometry.point(1, 1))
  elseif mode == "string" then
    start = defaultIfNil(start, "a")
    stop = defaultIfNil(stop, "z")
    step = defaultIfNil(step, 1)
    addmethod = function(a, b)
      return string.char(string.byte(a) + b)
    end
  end

  local range = {}
  local current = start
  while current <= stop do
    table.insert(range, current)
    current = addmethod(current, step)
  end

  return range
end
