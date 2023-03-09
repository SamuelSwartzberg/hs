--- since lists with nil are not considered lists by lua, this function will need to be called for any operation that might return a list with nil
--- @generic T
--- @param tbl T[]
--- @return T[]
function fixListWithNil(tbl)
  local new_tbl = {}
  for i = 1, #tbl do
    if tbl[i] ~= nil then
      new_tbl[#new_tbl + 1] = tbl[i]
    end
  end
  return new_tbl
end
