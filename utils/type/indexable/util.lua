--- @class tableProcOpts
--- @field args kvmult if there's a callback (or equivalent thing), what of the element does it recieve in which order?
--- @field ret kvmult what of the element does the callback (or equivalent thing) return in which order?
--- @field output "table" | "ovtable" whether to use a normal table or an ovtable
--- @field tolist boolean instead of replacing the element, append result to a list
--- @field last boolean iterate in reverse / use the last element, as the case may be
--- @field start integer only consider elements with or after this index
--- @field stop integer only consider elements with or before this index
--- @field limit integer limit the number of iterations

--- @param opts any 
--- @param retdefault? kvmult
--- @return table
function defaultOpts(opts, retdefault)
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

--- @param opts table
--- @return function
function getIterator(opts)
  return wdefarg(function(tbl) return prs(tbl, opts.start, opts.stop, opts.last and -1 or 1) end, opts.limit)
end

--- @alias retriever {k: any, v: any, i: integer}

--- TODO: no tests yet
--- @param thing indexable
--- @param k any
--- @param v any
--- @param manual_counter integer
--- @return retriever, integer
function getRetriever(thing, k, v, manual_counter)
  manual_counter = manual_counter + 1
  return {
    k = k,
    v = v,
    i = getIndex(thing, k, manual_counter)
  }, manual_counter
end


--- @param thing indexable
--- @param opts? table
--- @return indexable
function getEmptyResult(thing, opts)
  opts = opts or {}
  if opts.tolist  then -- manual case 1
    return list({})
  elseif opts.output == "table" then -- manual case 2
    return assoc({})
  elseif opts.output == "ovtable" then -- manual case 2
    return ovtable.new()
  elseif type(thing) == "string" then -- inferred case 2
    return ""
  elseif type(thing) == "table" then -- inferred case 3
    if thing.isovtable then
      return ovtable.new()
    elseif isListOrEmptyTable(thing) then
      return list({})
    else
      return assoc({})
    end
  else 
    return {}
  end
end

--- @param retriever retriever
--- @param opts table
--- @return any
function getArgs(retriever, opts)
  local args = {}
  for _, arg in iprs(opts.args) do
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
  for index, ret in iprs(opts.ret) do
    mapped_useas[ret] = index
  end

  local newkey
  if mapped_useas.k ~= nil then newkey = itemres[mapped_useas.k] -- if I have specified an index of the output (itemres) to be the key, use that, even if the value retrieved is nil
  else newkey = k end -- otherwise, use the original key
  local newval
  if mapped_useas.v ~= nil then newval = itemres[mapped_useas.v] -- ditto for value
  else newval = v end 
  -- explanation: We want to be able to return nil in our processor (that feeds into itemres) and have that be the key/value in the result, so that we can delete things via map() and similar funcs. But we also want to be able to specify that we want to use the original key/value in the result.

  if opts.flatten and type(newval) == "table" then
    for resk, resv in prs(newval) do
      local optcopy = copy(opts)
      optcopy.ret = {"k", "v"}
      addToRes({resk, resv}, res, optcopy)
      
    end
  else
    if newkey == false or opts.tolist then -- use false as a key to indicate to push to array instead
      table.insert(res, newval)
    else
      if not (opts.nooverwrite and res[newkey]) then
        if newkey ~= nil then 
          res[newkey] = newval
        end -- else no-op, don't add nil keys
      end
    end
   
  end
  return res -- typically, this is not needed, but it's here if needed, mainly in tests
end


--- @param opts table
--- @return boolean
function shouldRecurse(opts)
  return  (opts.recurse == true or (type(opts.recurse) == "number" and opts.recurse > opts.depth))
end