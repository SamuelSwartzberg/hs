
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

--- @generic T : any | any[]
--- @param tbl T[]
--- @param depth? integer
--- @return any[]
function listFlatten(tbl, depth) -- does not work on array tables
  if not tbl then return {} end
  if not isListOrEmptyTable(tbl) then return tbl end
  if not depth then depth = 1 end

  local new_tbl = {}
  for i, v in ipairs(tbl) do
    if type(v) == "table" and depth > 0 then
      local deeper_res = listFlatten(v, depth - 1)
      new_tbl = listConcat(new_tbl, deeper_res)
    else
      new_tbl[#new_tbl + 1] = v
    end
  end
  return new_tbl
end

--- @generic T
--- @generic O
--- @param tbl T[]
--- @param func fun(value: T): O|O[]
--- @return O[]
function flatMap(tbl, func)
  local res = listFlatten(map(tbl, func), 1)
  return res
end

--- @generic T
--- @generic O
--- @param tbl T[]
--- @param func fun(value: T): O
--- @return O[]
function filterNilMap(tbl, func)
  local new_tbl = {}
  for _, v in ipairs(tbl) do
    local new_v = func(v)
    if new_v ~= nil then
      new_tbl[#new_tbl + 1] = new_v
    end
  end
  return new_tbl
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
--- @param sorter? fun(a: T, b: T):boolean
--- @return T[]
function listSort(list, sorter)
  local new_list = tablex.copy(list)
  table.sort(new_list, sorter)
  return new_list
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


--- joins a list of lists into a single list, optionally inserting 1 - n elements between each list
--- @generic T
--- @generic U
--- @param list T[]
--- @param joiner U[]
--- @return (T | U)[]
function listJoin(list, joiner)
  local new_list = {}
  for i, v in wdefarg(ipairs)(list) do
    new_list = listConcat(new_list, v)
    if i < #list then
      new_list = listConcat(new_list, joiner)
    end
  end
  return new_list
end

--- @generic T
--- @param list T[]
--- @return T
function getLast(list)
  return list[#list]
end

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