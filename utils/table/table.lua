-- new function map that generalizes over all map scenarios

--- @alias kv "k"|"v"|string string here for stuff like "kv" or weirder stuff like "kkkkvkkvv"
--- @alias kvmult kv | kv[]

--- @class mapOpts
--- @field args kvmult
--- @field useas kvmult
--- @field noovtable boolean
--- @field mapcondition conditionSpec TODO NOT USED YET

--- @param tbl? table | nil
--- @param f? function 
--- @param opts? kvmult | kvmult[] | mapOpts
function map(tbl, f, opts)
  tbl = tbl or {}
  f = f or returnAny
  if type(opts) == "string" then
    opts = {args = opts, useas = opts}
  elseif isListOrEmptyTable(opts) then
    opts = {args = opts[1] or {"v"}, useas = opts[2] or {"v"}}
  else
    opts = opts or {}
    opts.args = opts.args or {"v"}
    opts.useas = opts.useas or {"v"}
  end

  if type(opts.args) == "string" then
    opts.args = splitChars(opts.args)
  end
  if type(opts.useas) == "string" then
    opts.useas = splitChars(opts.useas)
  end

  local mapped_useas = {}
  for index, useas in ipairs(opts.useas) do
    mapped_useas[useas] = index
  end

  local res
  local is_list = isListOrEmptyTable(tbl)

  if is_list then -- a list has int keys, which ovtable doesn't support, and we don't want the overhead of ovtable for a list anyway
    opts.noovtable = true
  end
  

  if opts.noovtable then
    res = {}
  else 
    res = ovtable.new()
  end

  for k, v in wdefarg(pairs)(tbl) do
    local retriever = {
      k = k,
      v = v
    }
    local args = {}
    for _, arg in ipairs(opts.args) do
      table.insert(args, retriever[arg])
    end
    local itemres = {f(table.unpack(args))}
    local newkey = itemres[mapped_useas.k]
    local newval = itemres[mapped_useas.v]
    if newkey == false then -- use false as a key to indicate to push to array instead
      table.insert(res, newval)
    else
      res[newkey] = newval
    end
  end

  return res
end

--- @class filterOpts
--- @field args kvmult
--- @field noovtable boolean
--- @field tolist boolean

--- @param tbl? table | nil
--- @param cond? conditionSpec
--- @param opts? kvmult | filterOpts
function filter(tbl, cond, opts)
  tbl = tbl or {}
  cond = cond or false
  if type(opts) == "string" or isListOrEmptyTable(opts) then
    opts = {args = opts}
  else
    opts = tablex.deepcopy(opts) or {}
  end

  local iterator = pairs
  
  local is_list = isListOrEmptyTable(tbl)

  if is_list then 
    opts.noovtable = true
    iterator = ipairs
  end
  

  if opts.noovtable or opts.tolist then
    res = {}
  else 
    res = ovtable.new()
  end

  for k, v in wdefarg(iterator)(tbl) do
    local retriever = {
      k = k,
      v = v
    }
    local res = true
    for _, arg in ipairs(opts.args) do
      res = res and test(retriever[arg], cond)
      if not res then
        break -- exit early
      end
    end
    if res then
      if opts.tolist then
        table.insert(res, v)
      else
        res[k] = v
      end
    end
  end

  return res
end

--- @class findOpts
--- @field args kvmult
--- @field ret kvmult here, kvmult can also include "boolean", to return a boolean instead of the value
--- more tbd

--- @param tbl? table | nil
--- @param cond? conditionSpec
--- @param opts? kvmult | kvmult[] | findOpts
function find(tbl, cond, opts)
  tbl = tbl or {}
  cond = cond or false
  if type(opts) == "string" then
    opts = {args = opts, ret = opts}
  elseif isListOrEmptyTable(opts) then
    opts = {args = opts[1] or {"v"}, ret = opts[2] or {"v"}}
  else
    opts = opts or {}
    opts.args = opts.args or {"v"}
    opts.ret = opts.ret or {"v"}
  end

  if type(opts.args) == "string" then
    opts.args = splitChars(opts.args)
  end
  if type(opts.ret) == "string" then
    if opts.ret == "boolean" then
      opts.ret = {"boolean"}
    else
      opts.ret = splitChars(opts.ret)
    end
  end

  local iterator

  if isListOrEmptyTable(tbl) then
    iterator = ipairs
  else
    iterator = pairs
  end

  for k, v in wdefarg(iterator)(tbl) do
    local retriever = {
      k = k,
      v = v
    }
    for _, arg in ipairs(opts.args) do
      res = res and test(retriever[arg], cond)
      if res then
        local ret = {}
        for _, retarg in ipairs(opts.ret) do
          if retarg == "boolean" then
            table.insert(ret, true)
          else
            table.insert(ret, retriever[retarg])
          end
        end
        return table.unpack(ret)
      end
    end
  end

  return nil
end

  


--- @generic K
--- @generic V
--- @param tbl {[`K`]: `V`}
--- @param key K
--- @return V
function getValue(tbl, key)
  return tbl[key]
end

--- @param tbl table
--- @param f fun(value?: any): any
function mapValueNewValueRecursive(tbl, f)
  local t = {}
  for k, v in wdefarg(pairs)(tbl) do
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
--- @param tbl { [`K`]: `V` } | nil
--- @return K[]
function keys(tbl)
  local t = {}
  for k, _ in wdefarg(pairs)(tbl) do
    t[#t + 1] = k
  end
  return t
end

--- @param tbl table
--- @return integer
function tbllength(tbl)
  local i = 0
  for _, _ in wdefarg(pairs)(tbl) do
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
  for _, v in wdefarg(pairs)(tbl) do
    t[#t + 1] = v
  end
  return t
end

function pairsList(tbl)
  local t = {}
  for k, v in wdefarg(pairs)(tbl) do
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
  for k, _ in wdefarg(pairs)(tbl) do
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
  for _, v in wdefarg(pairs)(tbl) do
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
  for _, v in wdefarg(pairs)(tbl) do
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
  for k, v in wdefarg(pairs)(t1) do
    new_table[k] = v
  end
  for k, v in wdefarg(pairs)(t2) do
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
  for k, v in wdefarg(pairs)(t1) do
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
  for k, v in wdefarg(pairs)(tbl) do
    f(k, v)
  end
end

--- @generic K
--- @generic V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(key?: K)
function forKeys(tbl, f)
  for k, _ in wdefarg(pairs)(tbl) do
    f(k)
  end
end

--- @generic K
--- @generic V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(value?: V)
function forValues(tbl, f)
  for _, v in wdefarg(pairs)(tbl) do
    f(v)
  end
end

--- @generic K, V, T, U
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(acc?: T | U, key?: K): T | U
--- @param initial T
--- @return T | U
function reduceKeys(tbl, f, initial)
  local acc = initial
  for k, _ in wdefarg(pairs)(tbl) do
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
  for _, v in wdefarg(pairs)(tbl) do
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
  for k, v in wdefarg(pairs)(tbl) do
    acc = f(acc, k, v)
  end
  return acc
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(key?: K): boolean
--- @return boolean
function allKeysPass(tbl, f)
  for k, v in wdefarg(pairs)(tbl) do
    if not f(k) then return false end
  end
  return true
end

--- @generic K, V
--- @param tbl {[K]: V} | nil
--- @param f fun(value?: V): boolean
--- @return boolean
function allValuesPass(tbl, f)
  for k, v in wdefarg(pairs)(tbl) do
    if not f(v) then return false end
  end
  return true
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(key?: K, value?: V): boolean
--- @return boolean
function allPairsPass(tbl, f)
  for k, v in wdefarg(pairs)(tbl) do
    if not f(k, v) then return false end
  end
  return true
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(key?: K): boolean
--- @return boolean
function someKeysPass(tbl, f)
  for k, v in wdefarg(pairs)(tbl) do
    if f(k) then return true end
  end
  return false
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(value?: V): boolean
--- @return boolean
function someValuesPass(tbl, f)
  for k, v in wdefarg(pairs)(tbl) do
    if f(v) then return true end
  end
  return false
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(key?: K, value?: V): boolean
--- @return boolean
function somePairsPass(tbl, f)
  for k, v in wdefarg(pairs)(tbl) do
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
  for k, v in wdefarg(pairs)(tbl) do
    if f(k) then return k end
  end
  return nil
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(value?: V): boolean
--- @return V | nil
function valueFind(tbl, f)
  for k, v in wdefarg(pairs)(tbl) do
    if f(v) then return v end
  end
  return nil
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(key?: K, value?: V): boolean
--- @return K, V | nil
function pairFind(tbl, f)
  for k, v in wdefarg(pairs)(tbl) do
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
  for k, v in wdefarg(pairs)(tbl) do
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
  for k, v in wdefarg(pairs)(tbl) do
    if f(v) then last_value = v end
  end
  return last_value
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param str string 
--- @return K | nil
function keyFindString(tbl, str)
  for k, v in wdefarg(pairs)(tbl) do
    if k == str then return k end
  end
  return nil
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param str string
--- @return V | nil
function valueFindString(tbl, str)
  for k, v in wdefarg(pairs)(tbl) do
    if v == str then return v end
  end
  return nil
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param str string 
--- @return K | nil
function keyFindStringEndsWith(tbl, str)
  for k, v in wdefarg(pairs)(tbl) do
    if stringy.endswith(k, str) then return k end
  end
  return nil
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param str string 
--- @return V | nil
function valueFindStringEndsWith(tbl, str)
  for k, v in wdefarg(pairs)(tbl) do
    if stringy.endswith(v, str) then return v end
  end
  return nil
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(key?: K): boolean
--- @return V | nil
function keyFindValue(tbl, f)
  for k, v in wdefarg(pairs)(tbl) do
    if f(k) then return v end
  end
  return nil
end

--- @generic K, V
--- @param tbl {[`K`]: `V`} | nil
--- @param f fun(value?: V): boolean
--- @return K | nil
function valueFindKey(tbl, f)
  for k, v in wdefarg(pairs)(tbl) do
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
    local list_item_before, key_to_resolve, list_item_after = slice(list_item, 1, n_elem_to_resolve - 1), list_item[n_elem_to_resolve], slice(list_item, n_elem_to_resolve + 1)
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
  for k, v in wdefarg(pairs)(tbl) do
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
  for k, v in wdefarg(pairs)(tbl) do
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
  for k, v in wdefarg(pairs)(tbl) do
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