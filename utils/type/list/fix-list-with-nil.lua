--- removes all nil values from a list, to allow usage with lua list functions
--- less relevant now as most of the list functions I've written now support nil values
--- @generic T
--- @param tbl T[]
--- @return T[]
function fixListWithNil(tbl)
  local new_tbl = list({})
  for i = 1, #tbl do
    if tbl[i] ~= nil then
      new_tbl[#new_tbl + 1] = tbl[i]
    end
  end
  return new_tbl
end
