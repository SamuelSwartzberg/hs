
--- @generic T
--- @param list_of_lists `T`[][]
--- @return T[]
function listOfListsGetCommonBeginningElements(list_of_lists)
  for i = 1, #list_of_lists[1] do
    if not listAllSameElements(array2d.column(list_of_lists, i)) then
      return listSlice(list_of_lists[1], 1, i - 1)
    end
  end
  return list_of_lists[1]
end