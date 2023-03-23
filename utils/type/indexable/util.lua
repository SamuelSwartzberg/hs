--- @class tableProcOpts
--- @field args kvmult if there's a callback (or equivalent thing), what of the element does it recieve in which order?
--- @field ret kvmult what of the element does the callback (or equivalent thing) return in which order?
--- @field tolist boolean instead of replacing the element, append result to a list
--- @field noovtable boolean if the output would be an assoc array, don't make it an ovtable (just make it a normal table)
--- @field last boolean iterate in reverse / use the last element, as the case may be
--- @field start integer only consider elements with or after this index
--- @field stop integer only consider elements with or before this index

--- @param opts any 
--- @param retdefault? kvmult
--- @return table
function defaultOpts(opts, retdefault)
  if not opts then opts = {ret = "boolean"} 
  elseif type(opts) == "table" and not isListOrEmptyTable(opts) and not opts.ret then opts.ret = "boolean" end
  if type(opts) == "string" then
    opts = {args = opts, ret = opts}
  elseif isListOrEmptyTable(opts) then
    opts = {args = opts[1] or {"v"}, ret = opts[2] or retdefault or {"v"}}
  else
    opts = copy(opts) or {}
    opts.args = opts.args or {"v"}
    opts.ret = opts.ret or retdefault or {"v"}
  end

  if type(opts.args) == "string" then
    opts.args = chars(opts.args)
  end
  if type(opts.ret) == "string" then
    if opts.ret == "boolean" then
      -- no-op
    else
      opts.ret = chars(opts.ret)
    end
  end

  return opts
end

--- @param thing table
--- @param opts table
--- @return function
function getIterator(thing, opts)
  local iter
  if isListOrEmptyTable(thing) then
    if opts.last then 
      iter = function(tbl) return revipairs(tbl, opts.start, opts.stop) end
    else 
      iter = function(tbl) return ipairs(tbl, opts.start, opts.stop) end 
    end
  else
    -- this would be the place to implement start/stop for non-lists, but that would be a lot of work, so for now, it's not supported
    if opts.last then  iter=  function(tbl) return tbl:revpairs() end 
    else iter = pairs end
  end
  return wdefarg(iter)
end

--- TODO: no tests yet
--- @param thing indexable
--- @param k any
--- @param v any
--- @param manual_counter integer
--- @return {k: any, v: any, i: integer}, integer
function getRetriever(thing, k, v, manual_counter)
  manual_counter = manual_counter + 1
  return {
    k = k,
    v = v,
    i = getIndex(thing, k, manual_counter)
  }, manual_counter
end


--- @param thing indexable
--- @param opts table
--- @return indexable
function getEmptyResult(thing, opts)
  if opts.tolist or opts.noovtable then
    return {}
  elseif isListOrEmptyTable(thing) then
    return {}
  elseif type(thing) == "string" then
    return ""
  else
    return ovtable.new()
  end
end

--- @param k any
--- @param v any
--- @param opts table
--- @return any
function getArgs(k, v, opts)
  local retriever = {
    k = k,
    v = v
  }
  local args = {}
  for _, arg in ipairs(opts.args) do
    table.insert(args, retriever[arg])
  end
  return args
end

--- @generic T : indexable
--- @param thing `T`
--- @return T
function getDefaultInput(thing)
  if type(thing) ~= "table" and type(thing) ~= "string" and type(thing) ~= "nil" then
    error("Expected table, string, or nil, got " .. type(thing))
  end
  return thing
end

function getIsLeaf(treat_as_leaf)
  if treat_as_leaf == "assoc" then
    return function(v) return not isListOrEmptyTable(v) end
  elseif treat_as_leaf == "list" then
    return isListOrEmptyTable
  elseif treat_as_leaf == false then
    return returnFalse
  else
    error("flatten: invalid value for treat_as_leaf: " .. tostring(treat_as_leaf))
  end
end

--- @param itemres any[] really should be [any, any], but lua type annotations don't support that
function addToRes(itemres,res,opts,k,v)
  local mapped_useas = {}
  for index, ret in ipairs(opts.ret) do
    mapped_useas[ret] = index
  end

  inspPrint(mapped_useas)

  local newkey
  if mapped_useas.k then newkey = itemres[mapped_useas.k] -- if I have specified an index of the output (itemres) to be the key, use that, even if the value retrieved is nil
  else newkey = k end -- otherwise, use the original key
  local newval
  if mapped_useas.v then newval = itemres[mapped_useas.v] -- ditto for value
  else newval = v end 
  -- explanation: We want to be able to return nil in our processor (that feeds into itemres) and have that be the key/value in the result, so that we can delete things via map() and similar funcs. But we also want to be able to specify that we want to use the original key/value in the result.
  inspPrint(newkey)
  inspPrint(newval)
  if newkey == false or opts.tolist then -- use false as a key to indicate to push to array instead
    table.insert(res, newval)
  else
    if not (opts.nooverwrite and res[newkey]) then
      if newkey ~= nil then 
        res[newkey] = newval
      end -- else no-op, don't add nil keys
    end
  end
  return res -- typically, this is not needed, but it's here if needed, mainly in tests
end

--- @param thing indexable
--- @param k string|integer
--- @param manual_counter? integer
--- @return integer
function getIndex(thing, k, manual_counter)
  if type(thing) == "table" then
    if thing.keyindex then
      return thing:keyindex(k) --[[ @as integer ]]
    else
      if not isListOrEmptyTable(thing) and manual_counter then
        return manual_counter
      else
        return k --[[ @as integer ]]
      end
    end
  else
    return k --[[ @as integer ]]
  end
end