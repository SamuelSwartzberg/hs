

--[[ --- @param all_elems { key: string, value: any }[]
--- @return table
function table.init(all_elems)
  local out = {}
  for i, v in ipairs(all_elems) do
    out[v.key] = v.value
  end
  return out
end

--- no difference to vanilla pairs on non-ordered tables
table.revpairs = pairs

table.pairs = pairs
table.ipairs = ipairs

--- @return table
function table.new()
  local tbl = {}
  local mt = { __index = table }
  setmetatable(tbl, mt)
  return tbl
end ]]

--- @generic T : table
--- @generic K
--- @generic V
--- @param tbl T | nil
--- @return (fun(table: table<K, V>,index?: K):K, V), T, nil
function pairsSafe(tbl)
  if not tbl then return pairs({}) end
  return pairs(tbl)
end

--- @generic T : table
--- @generic V
--- @param tbl T | nil
--- @return (fun(table: `V`[],i?: integer):integer, V), T, integer
function ipairsSafe(tbl)
  if not tbl then return ipairs({}) end
  return ipairs(tbl)
end

--- @generic K
--- @generic V
--- @generic O
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(key: K): `O`
--- @return {[O]: V}
function mapKeyNewKey(tbl, f)
  local t = {}
  for k, v in pairsSafe(tbl) do
    t[f(k)] = v
  end
  return t
end

--- @generic K
--- @generic V
--- @param tbl {[`K`]: `V`}
--- @param key K
--- @return V
function getValue(tbl, key)
  return tbl[key]
end

--- @generic K
--- @generic V
--- @generic O
--- @param tbl { [`K`]: `V` } | nil
--- @param f fun(value?: V): `O`
--- @return { [K]: O }
function mapValueNewValue(tbl, f)
  local t = {}
  for k, v in pairsSafe(tbl) do
    t[k] = f(v)
  end
  return t
end

--- @param tbl table
--- @param f fun(value?: any): any
function mapValueNewValueRecursive(tbl, f)
  local t = {}
  for k, v in pairsSafe(tbl) do
    if type(v) == "table" then
      t[k] = mapValueNewValueRecursive(v, f)
    else
      t[k] = f(v)
    end
  end
  return t
end

--- @generic K
--- @generic V
--- @generic O1
--- @generic O2
--- @param tbl { [`K`]: `V` } | nil
--- @param f fun(key?: K, value?: V): `O1`, `O2`
--- @return { [O1]: O2 }
function mapPairNewPair(tbl, f)
  local t = {}
  for k, v in pairsSafe(tbl) do
    local new_k, new_v = f(k, v)
    t[new_k] = new_v
  end
  return t
end

--- @param tbl table | nil
--- @param f fun(key?: any, value?: any): any, any
--- @return orderedtable
function mapPairNewPairOvtable(tbl, f)
  local t = ovtable.new()
  for k, v in pairsSafe(tbl) do
    local new_k, new_v = f(k, v)
    t[new_k] = new_v
  end
  return t
end



--- @generic K
--- @generic V
--- @generic O
--- @param tbl { [`K`]: `V` } | nil
--- @param f fun(key?: K, value?: V): `O`
--- @return O[]
function mapTableToArray(tbl, f)
  local t = {}
  for k, v in pairsSafe(tbl) do
    t[#t + 1] = f(k, v)
  end
  return t
end

--- @generic T
--- @param tbl T | nil
--- @return T
function mapValueToStrippedValue(tbl)
  return mapPairNewPairOvtable(tbl, function(k, v)
    if type(v) == "string" then
      return k, stringy.strip(v)
    else
      return k, v
    end
  end)
end

--- @param tbl table<any, any> | nil
--- @return table<any, string>
function mapValueToStr(tbl)
  return mapValueNewValue(tbl, function(v)
    return tostring(v)
  end)
end

--- @generic K
--- @generic V
--- @param tbl { [`K`]: `V` } | nil
--- @return K[]
function keys(tbl)
  local t = {}
  for k, _ in pairsSafe(tbl) do
    t[#t + 1] = k
  end
  return t
end

--- @param tbl table
--- @return integer
function tbllength(tbl)
  local i = 0
  for _, _ in pairsSafe(tbl) do
    i = i + 1
  end
  return i
end

--- @generic K
--- @generic V
--- @param tbl { [`K`]: `V` } | nil
--- @return V[]
function values(tbl)
  local t = {}
  for _, v in pairsSafe(tbl) do
    t[#t + 1] = v
  end
  return t
end

function pairsList(tbl)
  local t = {}
  for k, v in pairsSafe(tbl) do
    t[#t + 1] = {k, v}
  end
  return t
end

--- @generic K
--- @generic V
--- @param tbl { [`K`]: `V` } | nil
--- @return K[]
function sortedKeys(tbl)
  local t = keys(tbl)
  table.sort(t)
  return t
end

--- @generic K
--- @generic V
--- @param tbl { [`K`]: `V` } | nil
--- @return V[]
function sortedValues(tbl)
  local t = values(tbl)
  table.sort(t)
  return t
end

--- @generic K
--- @generic V
--- @param tbl {[`K`]: `V`} | nil
--- @param key any
--- @return boolean
function keysContain(tbl, key)
  for k, _ in pairsSafe(tbl) do
    if k == key then return true end
  end
  return false
end

--- @generic K
--- @generic V
--- @param tbl {[`K`]: `V`} | nil
--- @param value any
--- @return boolean
function valuesContain(tbl, value)
  for _, v in pairsSafe(tbl) do
    if v == value then return true end
  end
  return false
end

--- @generic K
--- @generic V
--- @param tbl { [`K`]: `V` } | nil
--- @param value any
--- @return boolean
function valuesContainShape(tbl, value)
  for _, v in pairsSafe(tbl) do
    if hs.inspect(v, {depth = 5}) == hs.inspect(value, {depth = 5}) then return true end
  end
  return false
end

--- @generic K1, V1, K2, V2
--- @param t1 { [`K1`]: `V1` } | nil
--- @param t2 { [`K2`]: `V2` } | nil
--- @return { [K1|K2]: V1|V2 }
function tableConcat(t1, t2)
  local new_table = {}
  for k, v in pairsSafe(t1) do
    new_table[k] = v
  end
  for k, v in pairsSafe(t2) do
    new_table[k] = v
  end
  return new_table
end

--- @generic K1, V1, K2, V2
--- @param t1 { [`K1`]: `V1` } | nil
--- @param t2 { [`K2`]: `V2` } | nil
--- @return { [K1|K2]: V1|V2 }
function copyKeysT1ToT2(t1, t2) -- in-place!
  if type(t1) ~= "table" or type(t2) ~= "table" then error("copyKeysT1ToT2: t1 and t2 must be tables") end
  if not t2 then t2 = {} end
  for k, v in pairsSafe(t1) do
    t2[k] = v
  end
  return t2
end

--- @generic T : table
--- @param t T
--- @return boolean
function tableIsEmpty(t)
  if not t then return true end
  return next(t) == nil
end

--- @param t table
--- @return boolean
function tableIsListOrEmpty(t)
  if tableIsEmpty(t) then return true end
  for k, v in pairs(t) do
    if type(k) ~= "number" then return false end
  end
  return true
end

--- @param t any
--- @return boolean
function isListOrEmptyTable(t)
  if type(t) ~= "table" then return false end
  return tableIsListOrEmpty(t)
end

--- @param t any
--- @return boolean
function isEmptyTable(t)
  if type(t) ~= "table" then return false end
  return tableIsEmpty(t)
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

--- length function that works for tables, thus also for sparse lists
--- @param t table
--- @return number
function tableLength(t)
  if not t then return 0 end
  local count = 0
  for _ in pairs(t) do
    count = count + 1
  end
  return count
end

--- @generic T 
--- @param potential_tbl primitive | T[]
--- @return primitive | ...<T>
function tableUnpackIfTable(potential_tbl)
  if type(potential_tbl) == "table" then
    return table.unpack(potential_tbl)
  else
    return potential_tbl
  end
end

--- @generic K
--- @generic V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(key?: K, value?: V)
function forEach(tbl, f)
  for k, v in pairsSafe(tbl) do
    f(k, v)
  end
end

--- @generic K
--- @generic V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(key?: K)
function forKeys(tbl, f)
  for k, _ in pairsSafe(tbl) do
    f(k)
  end
end

--- @generic K
--- @generic V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(value?: V)
function forValues(tbl, f)
  for _, v in pairsSafe(tbl) do
    f(v)
  end
end

--- @generic K, V, T
--- @param tbl {[`K`]: `V`} | nil
--- @param list T[]
--- @return { [K]: V }
function filterKeysInList(tbl, list)
  local t = {}
  for k, v in pairsSafe(tbl) do
    if valuesContain(list, k) then
      t[k] = v
    end
  end
  return t
end

--- @generic K, V, T
--- @param tbl {[`K`]: `V`} | nil
--- @param list T[]
--- @return { [K]: V }
function filterKeysNotInList(tbl, list)
  local t = {}
  for k, v in pairsSafe(tbl) do
    if not valuesContain(list, k) then
      t[k] = v
    end
  end
  return t
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(key?: K, value?: V): boolean
--- @return { [K]: V }
function filterKeys(tbl, f)
  local t = {}
  for k, v in pairsSafe(tbl) do
    if f(k, v) then
      t[k] = v
    end
  end
  return t
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(key?: K, value?: V): boolean
--- @return { [K]: V }
function filterValues(tbl, f)
  local t = {}
  for k, v in pairsSafe(tbl) do
    if f(k, v) then
      t[k] = v
    end
  end
  return t
end

--- @generic K, V, T, U
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(acc?: T | U, key?: K): T | U
--- @param initial T
--- @return T | U
function reduceKeys(tbl, f, initial)
  local acc = initial
  for k, _ in pairsSafe(tbl) do
    acc = f(acc, k)
  end
  return acc
end

--- @generic K, V, T, U
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(acc?: T | U, value?: V): T | U
--- @param initial T
--- @return T | U
function reduceValues(tbl, f, initial)
  local acc = initial
  for _, v in pairsSafe(tbl) do
    acc = f(acc, v)
  end
  return acc
end

--- @generic K, V, T, U
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(acc?: T | U, key?: K, value?: V): T | U
--- @param initial T
--- @return T | U
function reduceKeyValuePairs(tbl, f, initial)
  local acc = initial
  for k, v in pairsSafe(tbl) do
    acc = f(acc, k, v)
  end
  return acc
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(key?: K): boolean
--- @return boolean
function allKeysPass(tbl, f)
  for k, v in pairsSafe(tbl) do
    if not f(k) then return false end
  end
  return true
end

--- @generic K, V
--- @param tbl {[K]: V} | nil
--- @param f fun(value?: V): boolean
--- @return boolean
function allValuesPass(tbl, f)
  for k, v in pairsSafe(tbl) do
    if not f(v) then return false end
  end
  return true
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(key?: K, value?: V): boolean
--- @return boolean
function allPairsPass(tbl, f)
  for k, v in pairsSafe(tbl) do
    if not f(k, v) then return false end
  end
  return true
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(key?: K): boolean
--- @return boolean
function someKeysPass(tbl, f)
  for k, v in pairsSafe(tbl) do
    if f(k) then return true end
  end
  return false
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(value?: V): boolean
--- @return boolean
function someValuesPass(tbl, f)
  for k, v in pairsSafe(tbl) do
    if f(v) then return true end
  end
  return false
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(key?: K, value?: V): boolean
--- @return boolean
function somePairsPass(tbl, f)
  for k, v in pairsSafe(tbl) do
    if f(k, v) then return true end
  end
  return false
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(key?: K): boolean
--- @return boolean
function noKeysPass(tbl, f)
  return not someKeysPass(tbl, f)
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(value?: V): boolean
--- @return boolean
function noValuesPass(tbl, f)
  return not someValuesPass(tbl, f)
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(key?: K, value?: V): boolean
--- @return boolean
function noPairsPass(tbl, f)
  return not somePairsPass(tbl, f)
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(key?: K): boolean
--- @return K | nil
function keyFind(tbl, f)
  for k, v in pairsSafe(tbl) do
    if f(k) then return k end
  end
  return nil
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(value?: V): boolean
--- @return V | nil
function valueFind(tbl, f)
  for k, v in pairsSafe(tbl) do
    if f(v) then return v end
  end
  return nil
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(key?: K, value?: V): boolean
--- @return K, V | nil
function pairFind(tbl, f)
  for k, v in pairsSafe(tbl) do
    if f(k, v) then return k, v end
  end
  return nil
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(key?: K): boolean
--- @return K | nil
function keyFindLast(tbl, f)
  local last_key = nil
  for k, v in pairsSafe(tbl) do
    if f(k) then last_key = k end
  end
  return last_key
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(value?: V): boolean
--- @return V | nil
function valueFindLast(tbl, f)
  local last_value = nil
  for k, v in pairsSafe(tbl) do
    if f(v) then last_value = v end
  end
  return last_value
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param str string 
--- @return K | nil
function keyFindString(tbl, str)
  for k, v in pairsSafe(tbl) do
    if k == str then return k end
  end
  return nil
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param str string
--- @return V | nil
function valueFindString(tbl, str)
  for k, v in pairsSafe(tbl) do
    if v == str then return v end
  end
  return nil
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param str string 
--- @return K | nil
function keyFindStringEndsWith(tbl, str)
  for k, v in pairsSafe(tbl) do
    if stringy.endswith(k, str) then return k end
  end
  return nil
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param str string 
--- @return V | nil
function valueFindStringEndsWith(tbl, str)
  for k, v in pairsSafe(tbl) do
    if stringy.endswith(v, str) then return v end
  end
  return nil
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(key?: K): boolean
--- @return V | nil
function keyFindValue(tbl, f)
  for k, v in pairsSafe(tbl) do
    if f(k) then return v end
  end
  return nil
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(value?: V): boolean
--- @return K | nil
function valueFindKey(tbl, f)
  for k, v in pairsSafe(tbl) do
    if f(v) then return k end
  end
  return nil
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param target string
--- @return K | nil
function valueFindKeyString(tbl, target)
  return valueFindKey(tbl, function(v) return v == target end)
end

--- @generic T, V
--- @param list T[][]
--- @param assoc_arr { [`T`]: `V` }
--- @param n_elem_to_resolve integer
--- @return (T|V)[][]
function resolveListOfListsByAssocArr(list, assoc_arr, n_elem_to_resolve)
  local t = {}
  for _, list_item in ipairs(list) do
    local list_item_before, key_to_resolve, list_item_after = listSlice(list_item, 1, n_elem_to_resolve - 1), list_item[n_elem_to_resolve], listSlice(list_item, n_elem_to_resolve + 1)
    local resolved = assoc_arr[key_to_resolve]
    if resolved then
      local new_list = listFlatten({list_item_before, resolved, list_item_after})
      t[#t+1] = new_list
    end
  end
  return t
end

--- @generic K
--- @generic V
--- @param tbl { [`K`]: `V` } | nil
--- @return { [V]: K }
function switchKeysAndValues(tbl)
  local t = {}
  for k, v in pairsSafe(tbl) do
    t[v] = k
  end
  return t
end

-- simple helpers for higher-order functions

--- @generic K, V
--- @param k K
--- @param v? V 
--- @return K
function returnKey(k, v)
  return k
end

--- @generic K, V
--- @param k K
--- @param v? V 
--- @return V
function returnValue(k, v)
  return v
end

-- generators, iterators

sipairs = toStatefulGenerator(ipairs)
spairs = toStatefulGenerator(pairs)
skeys = toStatefulGenerator(pairs, 1, 1)
svalues = toStatefulGenerator(pairs, 2, 2)
sikeys = toStatefulGenerator(ipairs, 1, 1)
sivalues = toStatefulGenerator(ipairs, 2, 2)

--- tests that prevent errors in indexing 

--- @param entity any
--- @param key string
--- @return boolean
function hasKey(entity, key)
  return type(entity) == "table" and entity[key] ~= nil
end

--- @param entity any
--- @param key string
--- @param method? string
--- @return boolean
function methodTakesKey(entity, key, method)
  if not method then method = "get" end
  return 
    type(entity) == "table" and 
    type(entity[method]) == "function" and 
    entity[method](entity, key) ~= nil
end

--- @param entity any
--- @param key string
--- @param method? string
--- @return boolean
function methodIsTruthyForKey(entity, key, method)
  if not method then method = "get" end
  return 
    type(entity) == "table" and 
    type(entity[method]) == "function" and 
    entity[method](entity, key)
end

--- take an arbitrarily nested table and return a list of leaf values
---@param tbl any
---@return any[]
function collectLeaves(tbl)
  local t = {}
  for k, v in pairsSafe(tbl) do
    if type(v) == "table" then
      local leaves = collectLeaves(v)
      for _, leaf in ipairs(leaves) do
        t[#t+1] = leaf
      end
    else
      t[#t+1] = v
    end
  end
  return t
end


--- @param tbl table|nil
--- @param chunk_size integer
--- @return table[]
function chunk(tbl, chunk_size)
  local t = {}
  local chunk = {}
  if chunk_size < 1 then return {tbl} end -- chunk size of 0 or less  = no chunking
  for k, v in pairsSafe(tbl) do
    chunk[k] = v
    if tbllength(chunk) == chunk_size then
      t[#t+1] = chunk
      chunk = {}
    end
  end
  if tbllength(chunk) > 0 then
    t[#t+1] = chunk
  end
  return t
end