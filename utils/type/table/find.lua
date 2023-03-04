-- TODO multiple return? = find all option

--- @class findOpts
--- @field args kvmult
--- @field ret kvmult here, kvmult can also include "boolean", to return a boolean instead of the value
--- @field last boolean
--- @field findall boolean
--- @field start integer
--- @field stop integer

--- @param tbl? indexable | nil
--- @param cond? conditionSpec
--- @param opts? kvmult | kvmult[] | findOpts
function find(tbl, cond, opts)
  if not tbl or  #tbl == 0 then
    return nil -- default falsy value if table is empty, since there is nothing to find
  end
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

  local is_list = isListOrEmptyTable(tbl)
  local is_string = type(tbl) == "string"

  if opts.start or opts.stop then
    if is_list or is_string then
      tbl = slice(tbl, opts.start, opts.stop)
    else
      error("start and stop options don't work for non-list tables")
    end
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

  if not is_string then
    local iterator

    if is_list then
      iterator = ipairs
      if opts.last then tbl = rev(tbl) end
    else
      iterator = pairs
      if opts.last then error("last option not implemented for non-list tables") end
    end

    local finalres 
    if opts.findall then finalres = {} end

    for k, v in wdefarg(iterator)(tbl) do
      local retriever = {
        k = k,
        v = v
      }
      local res = true
      for _, arg in ipairs(opts.args) do
        res = res and findsingle(retriever[arg], cond)
      end
      if res then
        local ret = {}
        for _, retarg in ipairs(opts.ret) do
          if retarg == "boolean" then
            table.insert(ret, true)
          else
            table.insert(ret, retriever[retarg])
          end
        end
        if opts.findall then
          table.insert(finalres, ret)
        else
          return table.unpack(ret)
        end
      end

    end
  else
    -- TODO: I've thought about this a lot, and I think the best way to do this is to
    --   have _contains and _r of the conditionSpec be implemented here as plain/regex string search, where we interpret the index returned as k, and the match as v
    --   for any other condition, we just pass it on to test. given test returns true:
    --     for _start and _stop, we can use 0 / #tbl - #_stop as k, and the value of _start / _stop as v 
    --     for _exactly, we can use 0 as k, and the value of _exactly as v
    --     for _empty, we can use 0 as k, and "" as v
    --     for _type and _list, we can use 0 as k, and the entire string as v
    --     we should probably disallow _invert, since it doesn't make sense in this context
    -- maybe this logic should be in test instead of here? or maybe it should be in a separate function?

  end

  return finalres
end