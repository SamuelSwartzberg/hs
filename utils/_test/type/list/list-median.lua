--- @generic T
--- @param list T[]
--- @param comp fun(a: T, b: T):boolean
--- @param if_even "lower" | "higher" | "both"
--- @return T
function listMedian(list, comp, if_even)
  if_even = if_even or "lower"
  list = tablex.copy(list) -- don't modify the original list
  table.sort(list, comp)
  local mid = math.floor(#list / 2)
  if #list % 2 == 0 then
    if if_even == "lower" then
      return list[mid]
    elseif if_even == "higher" then
      return list[mid + 1]
    else
      return {list[mid], list[mid + 1]}
    end
  else
    return list[mid + 1]
  end
end

