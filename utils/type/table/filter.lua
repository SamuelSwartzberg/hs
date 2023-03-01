
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
