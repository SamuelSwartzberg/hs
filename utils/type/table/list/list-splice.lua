--- @generic T, U
--- @param list1 T[]
--- @param list2 U[]
--- @param splice_before integer
--- @return (T|U)[]
function listSplice(list1, list2, splice_before)
  local new_list = {}
  if #list1 < splice_before then
    return concat(list1, list2)
  else
    for i, v in ipairs(list1) do
      if i == splice_before then
        for _, v2 in ipairs(list2) do
          new_list[#new_list + 1] = v2
        end
      end
      new_list[#new_list + 1] = v
    end
  end
  return new_list
end