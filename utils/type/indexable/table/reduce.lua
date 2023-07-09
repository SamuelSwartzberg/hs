--- @class reduceOpts : tableProcOpts
--- @field init any

--- @generic K, V, O
--- @param tbl? table<K, V>
--- @param reducer? fun(acc: O, ...: K | V): O
--- @param opts? any | reduceOpts
--- @return O
function reduce(tbl, reducer, opts)

  -- defaults for all args

  reducer = reducer or transf.two_comparables.larger
  opts = defaultOpts(opts)
  tbl = getDefaultInput(tbl)

  local iterator = getIterator(opts)

  local acc_needs_to_be_populated = opts.init == nil
  -- if no init value is given, use the first value in the table as the acc, which removes the need for handling a nil acc in the reducer

  local acc = opts.init
  local manual_counter = 0
  for k, v in iterator(tbl) do
    local retriever
    retriever, manual_counter = getRetriever(tbl, k, v, manual_counter)
    local args = getArgs(retriever, opts)
    if acc_needs_to_be_populated then
      acc = args[1]
      acc_needs_to_be_populated = false
    else
      acc = reducer(acc, table.unpack(args))
    end
  end
  return acc
end

