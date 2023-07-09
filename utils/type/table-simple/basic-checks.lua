--- according to this function, a table is a list if:
--- 1. it is a table
--- 2. it is not manually declared to be an assoc or ovtable
--- 3. either:
---     1. it is manually declared to be a list
---     2. it has no keys that are not numbers and at least one key
--- @return boolean, boolean?
function isList(t)
  if type(t)~= "table" then return false end -- not a table
  if t.isarr then return true end -- signal value to indicate that this is a list
  if t.isassoc then return false end -- signal value to indicate that this is an assoc table
  if t.isovtable then return false end
  local count = 0
  for k, v in pairs(t) do
    if type(k) ~= "number" then return false end
    count = count + 1
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