--- @class tableProcOpts
--- @field args kvmult
--- @field ret kvmult
--- @field tolist boolean
--- @field noovtable boolean
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