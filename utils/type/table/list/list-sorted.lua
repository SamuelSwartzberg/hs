
--- @generic T
--- @param list T[]
--- @return T[]
function listReverse(list)
  local new_list = {}
  for i = #list, 1, -1 do
    new_list[#new_list + 1] = list[i]
  end
  return new_list
end

--- @generic T
--- @param list T[]
--- @param sorter? fun(a: T, b: T):boolean
--- @return T[]
function listSort(list, sorter)
  local new_list = tablex.copy(list)
  table.sort(new_list, sorter)
  return new_list
end