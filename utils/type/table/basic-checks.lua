--- @param t any
--- @return boolean
function isListOrEmptyTable(t)
  if type(t) ~= "table" then return false end
  for k, v in pairs(t) do
    if type(k) ~= "number" then return false end
  end
  return next(t) == nil
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