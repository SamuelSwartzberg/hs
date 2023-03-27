function assoc(tbl)
  local metatbl = {
      __index = {
          isassoc = true
      }
  }
  setmetatable(tbl, metatbl)
  return tbl
end