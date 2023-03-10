--- @class tableProcOpts
--- @field args kvmult
--- @field ret kvmult not: reduce()
--- @field tolist boolean not: reduce()
--- @field noovtable boolean not: reduce()
--- @field last boolean
--- @field start integer
--- @field stop integer

--- @param opts any 
--- @return table
function defaultOpts(opts)
  if type(opts) == "string" then
    opts = {args = opts, ret = opts}
  elseif isListOrEmptyTable(opts) then
    opts = {args = opts[1] or {"v"}, ret = opts[2] or {"v"}}
  else
    opts = tablex.deepcopy(opts) or {}
    opts.args = opts.args or {"v"}
    opts.ret = opts.ret or {"v"}
  end

  if type(opts.args) == "string" then
    opts.args = chars(opts.args)
  end
  if type(opts.ret) == "string" then
    if opts.ret == "boolean" then
      opts.ret = {"boolean"}
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
    if opts.last then  iter=  function(tbl) return ipairs(rev(tbl)) end 
    else iter = ipairs end
  else
    if opts.last then  iter=  function(tbl) return tbl:revpairs() end 
    else iter = pairs end
  end
  return wdefarg(iter)
end

--- @param thing indexable
--- @param opts table
--- @return indexable
function getEmptyResult(thing, opts)
  if opts.tolist or opts.noovtable then
    return {}
  elseif isListOrEmptyTable(thing) then
    return {}
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
--- @param opts table
--- @return T
function getDefaultInput(thing, opts)
  if type(thing) ~= "table" and type(thing) ~= "string" and type(thing) ~= "nil" then
    error("Expected table, string or, got " .. type(thing))
  end
  if opts.start or opts.stop then
    return slice(thing, opts.start, opts.stop)
  else
    return thing
  end
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

function addToRes(itemres,res,opts,k,v)
  local mapped_useas = {}
  for index, ret in ipairs(opts.ret) do
    mapped_useas[ret] = index
  end

  local newkey
  if mapped_useas.k then newkey = itemres[mapped_useas.k] -- if I have specified an index of the output (itemres) to be the key, use that, even if the value retrieved is nil
  else newkey = k end -- otherwise, use the original key
  local newval
  if mapped_useas.v then newval = itemres[mapped_useas.v] -- ditto for value
  else newval = v end 
  -- explanation: We want to be able to return nil in our processor (that feeds into itemres) and have that be the key/value in the result, so that we can delete things via map() and similar funcs. But we also want to be able to specify that we want to use the original key/value in the result.
  if newkey == false or opts.tolist then -- use false as a key to indicate to push to array instead
    table.insert(res, newval)
  else
    if not (opts.nooverwrite and res[newkey]) then
      res[newkey] = newval
    end
  end
end