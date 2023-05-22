--- according to this function, a table is a list if:
--- 1. it is a table
--- 2. it is not manually declared to be an assoc or ovtable
--- 3. either:
---     1. it is manually declared to be a list
---     2. it has no keys that are not numbers and at least one key
--- @param t any
--- @param also_allow_sparse? boolean
--- @return boolean, boolean?
function isList(t, also_allow_sparse)
  also_allow_sparse = defaultIfNil(also_allow_sparse, false)
  if type(t) ~= "table" then return false end -- not a table
  if t.islist then return true end -- signal value to indicate that this is a list
  if t.isassoc then return false end -- signal value to indicate that this is an assoc table
  if t.isovtable then return false end
  local count = 0
  for k, v in pairs(t) do
    if type(k) ~= "number" then return false end
    count = count + 1
    if k ~= count and not also_allow_sparse then return false end
  end
  return count > 0, count == 0
end

--- @param t any
--- @param also_allow_sparse? boolean
--- @return boolean
function isListOrEmptyTable(t, also_allow_sparse)
  local is_def_list, is_empty = isList(t, also_allow_sparse)
  return is_empty or is_def_list
end

--- @param t any
--- @return boolean
function isEmptyTable(t)
  if type(t) ~= "table" then return false end
  for k, v in pairs(t) do
    return false
  end
  return true
end

--- A table is undeterminable if it's not manually declared to be a list, assoc, or ovtable, and it's empty. That is to say, an empty table is undeterminable if we have no way of knowing if it's a list, an assoc, or an ovtable.
--- @param t table
--- @return boolean
function isUndeterminableTable(t)
  if type(t) ~= "table" then return false end
  if t.isovtable then return false end
  if t.islist then return false end
  if t.isassoc then return false end
  return isEmptyTable(t)
end


--- determines if a table is a sparse list, i.e. a list with holes, which in lua doesn't support many list ops
--- @param t table
--- @return boolean
function isSparseList(t)
  if not t then return false end
  if #t == 0 then return false end
  for i = 1, #t do
    if t[i] == nil then return true end
  end
  return false
end

--- @param entity any
--- @param key string
--- @return boolean
function hasKey(entity, key)
  return type(entity) == "table" and entity[key] ~= nil
end

--- @param t any[]
--- @param v any
--- @return boolean
function listContains(t, v)
  for _, v2 in ipairs(t) do
    if v2 == v then return true end
  end
  return false
end