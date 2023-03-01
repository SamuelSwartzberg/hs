
--- @generic T
--- @param tbl `T`[]|nil
--- @return { [T]: true }
function listToBoolTable(tbl)
  local value_bool_table = {}
  for _, v in wdefarg(ipairs)(tbl) do
    value_bool_table[v] = true
  end
  return value_bool_table
end

--- @generic T
--- @param tbl T[]|nil
--- @return T[]
function toSet(tbl)
  return keys(listToBoolTable(tbl))
end

function listFilterUniquePreserveFirst(tbl)
  local ovtable = ovtable.new()
  for _, v in ipairs(tbl) do
    ovtable[v] = true
  end
  local outtable = {}
  for k, _ in pairs(ovtable) do
    outtable[#outtable + 1] = k
  end
  return outtable
end

--- @generic T
--- @param list T[]
--- @param comp? fun(a: T, b: T):boolean
--- @return T
function listMax(list, comp)
  list = tablex.copy(list) -- don't modify the original list
  table.sort(list, comp)
  return list[#list]
end

--- @generic T
--- @param list T[]
--- @param comp fun(a: T, b: T):boolean
--- @return T
function listMin(list, comp)
  list = tablex.copy(list) -- don't modify the original list
  table.sort(list, comp)
  return list[1]
end

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

--- @generic T
--- @param list T[]
--- @param sample_size? integer defaults to 2
--- @return string
function listSampleString(list, sample_size)
  if not sample_size then sample_size = 2 end
  local listSample = slice(list, 1, sample_size)
  local outstr = stringx.join(", ", listSample)
  if #list > sample_size then
    outstr = outstr .. ", ..."
  end
  return outstr
end
