
--- @class filterOpts : tableProcOpts
--- @field findopts? findOptsWShorthand since the cond is a conditionSpec passed to find, you can pass options to find here

--- @generic T : table 
--- @param tbl? T | nil
--- @param cond? conditionSpec
--- @param opts? kvmult | filterOpts
--- @return T
function filter(tbl, cond, opts)

  -- defaults for all args

  cond = cond or false
  opts = defaultOpts(opts, {"k", "v"})
  tbl = getDefaultInput(tbl)

  local iterator = getIterator(opts)
  
  local res = getEmptyResult(tbl, opts)

  local manual_counter = 0
  for k, v in iterator(tbl) do
    print(k, v)
    local retriever
    retriever, manual_counter = getRetriever(tbl, k, v, manual_counter)
    local boolres = true
    for _, arg in iprs(opts.args) do
      boolres = boolres and findsingle(retriever[arg], cond, opts.findopts)
      if not boolres then
        break -- exit early
      end
    end
    inspPrint(res)
    if boolres then
      addToRes({k, v}, res, opts)
    end
  end

  return res
end
