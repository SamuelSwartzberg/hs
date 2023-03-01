--- @generic T
--- @param list T[]
--- @param n integer
--- @return T[]
function listMultiply(list, n)
  local new_list = {}
  for i = 1, n do
    new_list = listConcat(new_list, list)
  end
  return new_list
end
