function list(tbl)
  local metatbl = {
      __index = {
          islist = true
      }
  }
  setmetatable(tbl, metatbl)
  return tbl
end