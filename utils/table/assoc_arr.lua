--- @generic K, V
--- @param assoc_arr { [`K`]: `V`}
--- @param fn fun(key: `K`, value: `V`): boolean
--- @return { [`K`]: `V`}
function assocArrFilter(assoc_arr, fn)
  local result = {}
  for k, v in pairs(assoc_arr) do
    if fn(k, v) then
      result[k] = v
    end
  end
  return result
end

--- @generic K, V
--- @param assoc_arr { [`K`]: `V`}
--- @return { [`K`]: `V`}
function assocArrFilterUnique(assoc_arr)
  local result = {}
  for k, v in pairs(assoc_arr) do
    if not valuesContain(result, v) then
      result[k] = v
    end
  end
  return result
end

--- @generic K1
--- @generic V1
--- @generic K2
--- @generic V2
--- @param assoc_arr1 { [`K1`]: `V1`}
--- @param assoc_arr2 { [`K2`]: `V2`}
--- @return { [K1 | K2]: V1 | V2 }
function mergeAssocArrRecursive(assoc_arr1, assoc_arr2)
  if not assoc_arr1 then return assoc_arr2 end
  if not assoc_arr2 then return assoc_arr1 end
  local result = {}
  for k, v in pairs(assoc_arr1) do
    result[k] = v
  end
  for k, v in pairs(assoc_arr2) do
    if type(v) == "table" then
      if type(result[k]) == "table" then
        result[k] = mergeAssocArrRecursive(result[k], v)
      else
        result[k] = v
      end
    else
      result[k] = v
    end
  end
  return result
end

--- @generic T
--- @generic U
--- @param list1 T[]
--- @param list2 U[]
--- @return { [`T`]: `U` }
function list1list2assocArrZip(list1, list2)
  local result = {}
  for i, v in ipairs(list1) do
    result[v] = list2[i]
  end
  return result
end

--- @generic K
--- @generic V
--- @param list_of_assoc_arrs { [`K`]: `V`}[]
--- @return { [`K`]: `V`}
function flattenListOfAssocArrs(list_of_assoc_arrs) -- will overwrite earlier keys with later keys, it's the caller's responsibility to deal with that
  local result = {}
  for i, assoc_arr in ipairs(list_of_assoc_arrs) do
    for k, v in pairs(assoc_arr) do
      result[k] = v
    end
  end
  return result
end

--- @param assoc_arr table<any, any>
--- @param path any[]
--- @return { path: any[], value: any}[]
function nestedAssocArrToListIncludingPath(assoc_arr, path)
  local result = {}
  for k, v in pairs(assoc_arr) do
    if type(v) == "table" and not isEmptyTable(v) then
      local cloned_path = tablex.copy(path)
      listPush(cloned_path, k)
      local sub_result = nestedAssocArrToListIncludingPath(v, cloned_path)
      for i, sub_result_item in ipairs(sub_result) do
        listPush(result, sub_result_item)
      end
    else
      local cloned_path = tablex.copy(path)
      listPush(cloned_path, k)
      listPush(result, {path = cloned_path, value = v})
    end
  end
  return result
end

--- @param assoc_arr table<any, any>
--- @return { depth: integer, path: any[], value: any}[]
function nestedAssocArrToListIncludingPathAndDepth(assoc_arr)
  local incl_path = nestedAssocArrToListIncludingPath(assoc_arr, {})
  return map(incl_path, function(item)
    return {depth = #item.path - 1, path = item.path, value = item.value}
  end)
end

--- @param assoc_arr table<any, string|table>
--- @param indentation? integer
--- @return { [string]: { key_stop: integer, value_stop: integer}}
function nestedAssocArrGetStopsForKeyValue(assoc_arr, indentation)
  if not indentation then indentation = 2 end
  local incl_path_and_depth = nestedAssocArrToListIncludingPathAndDepth(assoc_arr)
  local list_of_stops = mapPairNewPairOvtable(incl_path_and_depth, function(k, item)
    local key = item.path[#item.path]
    return key, {
      key_stop = (item.depth * indentation) + #key,
      value_stop = #item.value
    }
  end)
  return list_of_stops
end

--- @param assoc_arr table<any, string|table>
--- @param indentation? integer
--- @return integer, integer
function nestedAssocArrGetMaxStops(assoc_arr, indentation)
  local stops = nestedAssocArrGetStopsForKeyValue(assoc_arr, indentation)
  local key_stops = map(values(stops), function(stop)
    return stop.key_stop
  end)
  local value_stops = map(values(stops), function(stop)
    return stop.value_stop
  end)
  local max_key_stop = listMax(key_stops)
  local max_value_stop = listMax(value_stops)
  return max_key_stop, max_value_stop
end


--- @param assoc_arr table<any, any>
--- @return table<string[], any>
function nestedAssocArrToFlatPathAssocArr(assoc_arr)
  local list = nestedAssocArrToListIncludingPath(assoc_arr, {})
  return mapPairNewPairOvtable(list, function(_, item)
    return item.path, item.value
  end)
end

--- @param assoc_arr table<any, any>
--- @return table<string, any>
function nestedAssocArrToFlatPathAssocArrWithDotNotation(assoc_arr)
  local list = nestedAssocArrToListIncludingPath(assoc_arr, {})
  return mapPairNewPairOvtable(list, function(_, item)
    return table.concat(item.path, "."), item.value
  end)
end

--- @generic T : string
--- @param list { [string]: any, [T]: table | nil}[]
--- @param path? string[]
--- @param specifier? { children_key_name?: `T`, title_key_name?: string, levels_of_nesting_to_skip?: number, include_inner_nodes?: boolean }
--- @return { path: any[], [any]: any}[]
function listWithChildrenKeyToListIncludingPath(list, path, specifier)
  if not path then path = {} end
  if not specifier then specifier = {} end
  if not specifier.children_key_name then specifier.children_key_name = "children" end
  if not specifier.title_key_name then specifier.title_key_name = "title" end
  if not specifier.levels_of_nesting_to_skip then specifier.levels_of_nesting_to_skip = 0 end
  local result = {}
  for i, item in ipairs(list) do
    local cloned_path = tablex.copy(path)
    listPush(cloned_path, item[specifier.title_key_name])
    local children = item[specifier.children_key_name]
    if specifier.levels_of_nesting_to_skip > 0 and children then
      for i = 1, specifier.levels_of_nesting_to_skip do -- this is to handle cases in which instead of children being { item, item, ... }, it's {{ item, item, ... }} etc. Really, this shouldn't be necessary, but some of the data I'm working with is like that.
        children = children[1]
      end
    end
    if not isListOrEmptyTable(children) then children = nil end
    if specifier.include_inner_nodes or not children then -- if it doesn't have children (or we want to include inner nodes), add it to the result
      item.path = tablex.copy(path) -- not cloned_path as we want the path to be the path up to and including the parent, not the path up to and including the item. 
      item[specifier.children_key_name] = nil
      listPush(result, item)
    end
    if children then -- if it has children, recurse
      result = listConcat(result, listWithChildrenKeyToListIncludingPath(children, cloned_path, specifier))
    end
  end
  return result
end

--- @param assoc_arr table<any, any>
--- @return { path: any[], [any]: any}[]
function nestedAssocArrWithAssocArrLeavesToListIncludingPath(assoc_arr, path)
  local list_incl_path = nestedAssocArrToListIncludingPath(assoc_arr, path)
  return map(list_incl_path, function(item)
    local val = item.value
    val.path = item.path
    return val
  end)
end

--- @param list table[]
--- @param assoc_arr table
--- @return table[]
function mergeAssocArrWithAllListElements(list, assoc_arr)
  return map(list, function(item)
    return mergeAssocArrRecursive(item, assoc_arr)
  end)
end

--- @param assoc_arr table
--- @param key_transpose_table {[string]: string}
--- @return table
function transposeAssocArrKeys(assoc_arr, key_transpose_table)
  local assoc_arr_copy = tablex.copy(assoc_arr)
  for k, v in pairs(key_transpose_table) do
    assoc_arr_copy[v] = assoc_arr_copy[k]
    assoc_arr_copy[k] = nil
  end
  return assoc_arr_copy
end
  

--- @param timestamp_key_table orderedtable
--- @return { [string]: { [string]: { [string]: string[] } } }
function timestampKeyTableToYMDTable(timestamp_key_table)
  local year_month_day_time_table = {}
  for timestamp_str, fields in timestamp_key_table:revpairs() do 
    local timestamp = tonumber(timestamp_str)
    local year = os.date("%Y", timestamp)
    local year_month = os.date("%Y-%m", timestamp)
    local year_month_day = os.date("%Y-%m-%d", timestamp)
    local time = os.date("%H:%M:%S", timestamp)
    if not year_month_day_time_table[year] then year_month_day_time_table[year] = {} end
    if not year_month_day_time_table[year][year_month] then year_month_day_time_table[year][year_month] = {} end
    if not year_month_day_time_table[year][year_month][year_month_day] then year_month_day_time_table[year][year_month][year_month_day] = {} end
    local contents = listConcat({time}, fields)
    table.insert(year_month_day_time_table[year][year_month][year_month_day], contents)
  end
  return year_month_day_time_table
end


--- @param tbl table
--- @param key? string
--- @param ignore_plain_values? boolean
--- @param delete_key_if_empty? boolean
--- @return table|nil
function mapTableWithValueInCertainKeyToTableHoldingValueDirectly(tbl, key, ignore_plain_values, delete_key_if_empty)
  if ignore_plain_values == nil then ignore_plain_values = false end
  if not key then key = "value" end
  local result = ovtable.new()
  for k, v in pairs(tbl) do
    if type(v) ~= "table" then
      if not ignore_plain_values then result[k] = v end
      -- else do nothing
    elseif type(v) == "table" and v[key] then
      result[k] = v[key]
    else 
      result[k] = mapTableWithValueInCertainKeyToTableHoldingValueDirectly(v, key, ignore_plain_values, delete_key_if_empty)
    end
  end
  if delete_key_if_empty and isEmptyTable(result) then result = nil end
  return result
end