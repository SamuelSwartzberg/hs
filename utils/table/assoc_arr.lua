--- @class mergeOpts
--- @field isopts "isopts"
--- @field recursive boolean

--- @param opts? mergeOpts
--- @param ... table[]
--- @return table
function mergeAssocArrRecursive(opts, ...)
  local tables = {...}
  if not opts then return {} end 
  if opts.isopts == "isopts" then
    -- no-op
  else -- opts is actually the first associative array
    table.insert(tables, 1, opts)
    opts = {}
  end

  opts.recursive = defaultIfNil(opts.recursive, true)

  if #tables == 0 then return {} end
  local result = tablex.deepcopy(tables[1])
  for _, mergetable in wdefarg(ipairs)(tables) do 
    if type(mergetable) == "table" then
      for k, v in pairs(mergetable) do
        if type(v) == "table" then
          if type(result[k]) == "table" and opts.recursive then
            result[k] = mergeAssocArrRecursive(result[k], v)
          else
            result[k] = tablex.deepcopy(v)
          end
        else
          result[k] = v
        end
      end
    else
      error("mergeAssocArrRecursive: expected table, got " .. type(mergetable) .. "with contents:\n\n" .. json.encode(mergetable))
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
    if type(v) == "table" and #values(v) > 0 then
      local cloned_path = tablex.copy(path)
      push(cloned_path, k)
      local sub_result = nestedAssocArrToListIncludingPath(v, cloned_path)
      for i, sub_result_item in ipairs(sub_result) do
        push(result, sub_result_item)
      end
    else
      local cloned_path = tablex.copy(path)
      push(cloned_path, k)
      push(result, {path = cloned_path, value = v})
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
  local list_of_stops = map(incl_path_and_depth, function(item)
    local key = item.path[#item.path]
    return key, {
      key_stop = (item.depth * indentation) + #key,
      value_stop = #item.value
    }
  end, {"v", "kv"})
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
  return map(list, function(item)
    return item.path, item.value
  end, {"v", "kv"})
end

--- @param assoc_arr table<any, any>
--- @return table<string, any>
function nestedAssocArrToFlatPathAssocArrWithDotNotation(assoc_arr)
  local list = nestedAssocArrToListIncludingPath(assoc_arr, {})
  return map(list, function(item)
    return table.concat(item.path, "."), item.value
  end, {"v", "kv"})
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
    push(cloned_path, item[specifier.title_key_name])
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
      push(result, item)
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
  if delete_key_if_empty and #values(result) > 0 then result = nil end
  return result
end