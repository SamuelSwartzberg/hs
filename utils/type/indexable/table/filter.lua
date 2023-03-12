
--- @class filterOpts : tableProcOpts

--- @generic T : table 
--- @param tbl? T | nil
--- @param cond? conditionSpec
--- @param opts? kvmult | filterOpts
--- @return T
function filter(tbl, cond, opts)

  -- defaults for all args

  cond = cond or false
  opts = defaultOpts(opts)
  tbl = getDefaultInput(tbl, opts)

  local iterator = getIterator(tbl, opts)
  
  local res = getEmptyResult(tbl, opts)

  for k, v in iterator(tbl) do
    local retriever = {
      k = k,
      v = v
    }
    local res = true
    for _, arg in ipairs(opts.args) do
      res = res and findsingle(retriever[arg], cond)
      if not res then
        break -- exit early
      end
    end
    if res then
      addToRes({k, v}, res, opts)
    end
  end

  return res
end
