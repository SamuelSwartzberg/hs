--- @generic T
--- @param tbl T[]
--- @return T
function listPop(tbl)
  local last = tbl[#tbl]
  tbl[#tbl] = nil
  return last
end

--- @generic T, U
--- @param tbl T[]
--- @param value U
--- @return true
function listPush(tbl, value)
  tbl[#tbl + 1] = value
  return true
end

--- @generic T
--- @param tbl T[]
--- @return T
function listShift(tbl)
  local first = tbl[1]
  table.remove(tbl, 1)
  return first
end

--- @generic T, U
--- @param tbl T[]
--- @param value U
--- @return true
function listUnshift(tbl, value)
  table.insert(tbl, 1, value)
  return true
end

--- @generic T
--- @param tbl T[]
--- @param filter_func fun(value: T): boolean
--- @return T[]
function listFilter(tbl, filter_func)
  local new_tbl = {}
  for _, v in ipairs(tbl) do
    if filter_func(v) then
      new_tbl[#new_tbl + 1] = v
    end
  end

  return new_tbl

end

--- since lists with nil are not considered lists by lua, this function will need to be called for any operation that might return a list with nil
--- @generic T
--- @param tbl T[]
--- @return T[]
function fixListWithNil(tbl)
  local new_tbl = {}
  for i = 1, #tbl do
    if tbl[i] ~= nil then
      new_tbl[#new_tbl + 1] = tbl[i]
    end
  end
  return new_tbl
end

--- @generic T
--- @param tbl T[]
--- @return T[]
function listFilterEmptyString(tbl)
  return listFilter(tbl, function(x) return x ~= "" end)
end

--- @generic T
--- @param tbl `T`[]|nil
--- @return { [T]: true }
function listToBoolTable(tbl)
  local value_bool_table = {}
  for _, v in ipairsSafe(tbl) do
    value_bool_table[v] = true
  end
  return value_bool_table
end

--- @generic T
--- @param tbl T[]|nil
--- @return T[]
function listFilterUnique(tbl)
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

--- @alias flags { is_nil: boolean, is_primitive: boolean}


--- @generic T, U
--- @param list T[] | nil
--- @param values U[] | U
--- @return nil
local function addValuesToList(list, values)
  if not list then list = {} end
  if type(values) == "nil" then
    -- do nothing
  elseif not isListOrEmptyTable(values) then
    list[#list + 1] = values
  else
    for _, v in ipairs(values) do
      list[#list + 1] = v
    end
  end
end

--- @generic T, U
--- @param ... T[] | T | nil
--- @return (T | U)[]
function listConcat(...)
  local new_list = {}
  for _, list in ipairs({...}) do
    addValuesToList(new_list, list)
  end
  return new_list
end

--- @generic T, U
--- @param tbl T[]
--- @param value U
--- @return (T|U)[]
function listAppend(tbl, value) -- like listPush, but returns the table
  tbl[#tbl + 1] = value
  return tbl
end

--- @generic T, U
--- @param tbl T[]
--- @param value U
--- @return (T|U)[]
function listPrepend(tbl, value) -- like listUnshift, but returns the table
  table.insert(tbl, 1, value)
  return tbl
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
  local res = listFlatten(mapValueNewValue(tbl, func), 1)
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

--- @generic T, U
--- @param tbl T[] | nil
--- @param val U 
--- @return boolean
function listHasValue(tbl, val)
  if not tbl then return false end
  for index, value in ipairs(tbl) do
    if value == val then
      return true
    end
  end

  return false
end

function listOfTableFlatten(tbl) -- does not work on array tables
  local new_tbl = {}
  for k, v in pairs(tbl) do
    if type(v) == "table" then
      new_tbl = copyKeysT1ToT2(v, new_tbl)
    else
      new_tbl[k] = v
    end
  end
  return new_tbl
end

--- @generic T
--- @param list T[]
--- @param n "first" | "last" | integer
--- @return T
function listGetNth(list, n)
  if n == "first" then
    return list[1]
  elseif n == "last" then
    return list[#list]
  else
    if n > #list then
      error("no item for index: " .. n)
    end
    return list[n]
  end
end

--- @generic T, U
--- @param list1 T[]
--- @param list2 U[]
--- @param splice_before integer
--- @return (T|U)[]
function listSplice(list1, list2, splice_before)
  local new_list = {}
  if #list1 < splice_before then
    return listConcat(list1, list2)
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

--- @generic T
--- @param list T[]
--- @return T[]
function listCopy(list)
  local new_list = {}
  for i, v in ipairs(list) do
    new_list[i] = v
  end
  return new_list
end

--- @generic T
--- @param list T[]
--- @param joiner string
--- @return string
function listJoinIfNecessary(list, joiner)
  local outstr = ""
  for _, contents in ipairs(list) do
    if #contents > 0 and eutf8.sub(contents, -1) ~= joiner then
      contents = contents .. joiner
    end
    outstr = outstr .. contents
  end
  return outstr
end

--- @generic T
--- @param list T[]
--- @param comp? fun(a: T, b: T):boolean
--- @return T
function listMax(list, comp)
  list = listCopy(list) -- don't modify the original list
  table.sort(list, comp)
  return list[#list]
end

--- @generic T
--- @param list T[]
--- @param comp fun(a: T, b: T):boolean
--- @return T
function listMin(list, comp)
  list = listCopy(list) -- don't modify the original list
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
  list = listCopy(list) -- don't modify the original list
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
  local new_list = listCopy(list)
  table.sort(new_list, sorter)
  return new_list
end

--- @generic K, V
--- @param list {[`K`]: `V`} | nil
--- @return { [K]: V }
function toSet(list)
  return listFilterUnique(list)
end

--- @generic T, U
--- @param set1 T[]
--- @param set2 U[]
--- @return (T|U)[]
function setUnion(set1, set2)
  local new_list = listConcat(set1, set2)
  return toSet(new_list)
end

--- @generic T, U
--- @param set1 T[]
--- @param set2 U[]
--- @return (T|U)[]
function setIntersection(set1, set2)
  local new_list = {}
  for _, v in ipairs(set1) do
    if listHasValue(set2, v) then
      new_list[#new_list + 1] = v
    end
  end
  return toSet(new_list)
end

--- @generic T, U
--- @param set1 T[]
--- @param set2 U[]
--- @return boolean
function setEquals(set1, set2)
  if #set1 ~= #set2 then return false end
  for _, v in ipairs(set1) do
    if not listHasValue(set2, v) then
      return false
    end
  end
  return true
end

--- @generic T, U
--- @param set1 T[]
--- @param set2 U[]
--- @return boolean
function setIsSubset(set1, set2)
  for _, v in ipairs(set1) do
    if not listHasValue(set2, v) then
      return false
    end
  end
  return true
end

--- @generic T, U
--- @param set1 T[]
--- @param set2 U[]
--- @return boolean
function setIsSuperset(set1, set2)
  return setIsSubset(set2, set1)
end

--- @generic T, U
--- @param set1 T[]
--- @param set2 U[]
--- @return (T|U)[]
function setDifference(set1, set2)
  local new_list = {}
  for _, v in ipairs(set1) do
    if not listHasValue(set2, v) then
      new_list[#new_list + 1] = v
    end
  end
  return toSet(new_list)
end

--- @generic T, U
--- @param set1 T[]
--- @param set2 U[]
--- @return (T|U)[]
function setSymmetricDifference(set1, set2)
  local new_list = {}
  for _, v in ipairs(set1) do
    if not listHasValue(set2, v) then
      new_list[#new_list + 1] = v
    end
  end
  for _, v in ipairs(set2) do
    if not listHasValue(set1, v) then
      new_list[#new_list + 1] = v
    end
  end
  return toSet(new_list)
end

--- @generic K, V
--- @param list V[]
--- @return { [V]: V }
function listToAssocArray(list)
  local assoc_array = {}
  for _, v in ipairs(list) do
    local first_elem = v[1]
    local rest_of_list = slice(v, 2)
    assoc_array[first_elem] = rest_of_list
  end
  return assoc_array
end

--- @generic T
--- @param list T[]
--- @return boolean
function listAllSameElements(list)
  if #list == 0 then return true end
  local first_elem = list[1]
  for _, v in ipairs(list) do
    if v ~= first_elem then
      return false
    end
  end
  return true
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

-- sadly, since my language server doesn't support generics on class fields at the moment, we need to recreate all methods of 'combine' on our own so we can add type annotations using generics :(
-- while we're doing that, I'm also going to transform them into functions that return a table instead of an iterator

--- gets the k-combinations of a list
--- @generic T
--- @param list T[]
--- @param k integer 
--- @return T[][]
function combinations(list, k)
  if k == 0 then
    return {{}}
  else 
    return statefulNokeyIteratorToTable(combine.combn, list, k)
  end
end

--- @generic T
--- @param list T[]
--- @return T[][]
function permutations(list)
  if #list == 0 then
    return {{}}
  else
    return statefulNokeyIteratorToTable(combine.permute, list)
  end
end

--- @generic T
--- @param list T[]
--- @return T[][]
function powerset(list)
  if #list == 0 then
    return {{}}
  else
    local output = listConcat( statefulNokeyIteratorToTable(combine.powerset, list), {{}} )
    return output
  end
end

--- @generic T, O
--- @param list T[]
--- @param transformer fun(input: T[]):O
--- @return O[][]
function allTransformedCombinations(list, transformer)
  return mapValueNewValue(powerset(list), transformer)
end

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

--- joins a list of lists into a single list, optionally inserting 1 - n elements between each list
--- @generic T
--- @generic U
--- @param list T[]
--- @param joiner U[]
--- @return (T | U)[]
function listJoin(list, joiner)
  local new_list = {}
  for i, v in ipairsSafe(list) do
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