--- @class reduceOpts : tableProcOpts
--- @field init any

--- @param tbl? table
--- @param reducer? function
--- @param opts? any | reduceOpts
--- @return any
function reduce(tbl, reducer, opts)

  -- defaults for all args

  reducer = reducer or returnLarger
  opts = defaultOpts(opts)
  tbl = getDefaultInput(tbl, opts)

  local iterator = getIterator(tbl, opts)

  opts.init = opts.init or ""
 

  local acc = opts.init
  for k, v in iterator(tbl) do
    local args = getArgs(k, v, opts)
    acc = reducer(acc, table.unpack(args))
  end
  return acc
end

