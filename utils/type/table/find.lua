
--- @class findOpts
--- @field args kvmult
--- @field ret kvmult here, kvmult can also include "boolean", to return a boolean instead of the value
--- @field last boolean

--- @param tbl? table | nil
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

  local iterator

  if isListOrEmptyTable(tbl) then
    iterator = ipairs
    if opts.last then tbl = rev(tbl) end
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