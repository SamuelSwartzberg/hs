
--- @generic T
--- @param list_of_lists `T`[][]
--- @return T[]
function lolCommonPrefix(list_of_lists)
  for i = 1, #list_of_lists[1] do
    local column = array2d.column(list_of_lists, i)
    local all_same = not find(column, {
      _exactly = column[1],
      _invert = true,
    }, "boolean")
    if not all_same then
      return slice(list_of_lists[1], 1, i - 1)
    end
  end
  return list_of_lists[1]
end