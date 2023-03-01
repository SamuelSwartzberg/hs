-- new function map that generalizes over all map scenarios

--- @alias kv "k"|"v"|string string here for stuff like "kv" or weirder stuff like "kkkkvkkvv"
--- @alias kvmult kv | kv[]

--- @class mapOpts
--- @field args kvmult
--- @field useas kvmult
--- @field noovtable boolean
--- @field mapcondition conditionSpec TODO NOT USED YET

--- @param tbl? table | nil
--- @param f? function | table | string
--- @param opts? kvmult | kvmult[] | mapOpts
function map(tbl, f, opts)
  tbl = tbl or {}
  f = f or returnAny

  -- process shorthand opts into full opts

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

  -- process non-function f into function f

  if type(f) == "table" then
    local tbl = f
    f = function(arg)
      return tbl[arg]
    end
  elseif type(f) == "string" then
    local str = f
    f = function()
      return str, str
    end
  end

  -- set some vars we will need later

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
--- @field last boolean search from the end of the table TODO not yet implemented

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
    if opts.last then tbl = listReverse(tbl) end
  else
    iterator = pairs
    if opts.last then error("last option not yet implemented for non-list tables") end
  end

  for k, v in wdefarg(iterator)(tbl) do
    local retriever = {
      k = k,
      v = v
    }
    local res = true
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
--- @param value any
--- @return boolean
function valuesContainShape(tbl, value)
  for _, v in wdefarg(pairs)(tbl) do
    if hs.inspect(v, {depth = 5}) == hs.inspect(value, {depth = 5}) then return true end
  end
  return false
end

--- @alias tle "table" | "empty" | "list-or-empty" 

--- @param tbl table
--- @param things tle|tle[]
--- @return boolean
function tRelIs(tbl, things)
  if not tbl then return false end
  if type(things) == "string" then
    things = {things}
  end
  local res = true
  if find(things, "table") then
    res = res and type(tbl) == "table"
  end

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

-- generators, iterators

--- tests that prevent errors in indexing 

--- @param entity any
--- @param key string
--- @return boolean
function hasKey(entity, key)
  return type(entity) == "table" and entity[key] ~= nil
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
    if #keys(chunk) == chunk_size then
      t[#t+1] = chunk
      chunk = {}
    end
  end
  if #keys(chunk) > 0 then
    t[#t+1] = chunk
  end
  return t
end