--- @generic T
--- @param tbl T[]
--- @return T
function push(tbl)
  local last = tbl[#tbl]
  tbl[#tbl] = nil
  return last
end

--- @generic T, U
--- @param tbl T[]
--- @param value U
--- @return true
function pop(tbl, value)
  tbl[#tbl + 1] = value
  return true
end