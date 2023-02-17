--- @param amount number
---@param unit "s" | "m" | "h" | "D" | "W" | "M" | "Y"
---@return number
function toSeconds(amount, unit)
  local units = {
    s = 1,
    m = 60,
    h = 60 * 60,
    D = 60 * 60 * 24,
    W = 60 * 60 * 24 * 7,
    M = 60 * 60 * 24 * 30,
    Y = 60 * 60 * 24 * 365,
  }
  return amount * units[unit]
end
