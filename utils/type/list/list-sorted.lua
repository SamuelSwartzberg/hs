--- @generic T
--- @param list T[]
--- @param sorter? fun(a: T, b: T):boolean
--- @return T[]
function listSort(list, sorter)
  local new_list = copy(list, false)
  table.sort(new_list, sorter)
  return new_list
end