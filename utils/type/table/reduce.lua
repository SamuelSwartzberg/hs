--- @class reduceOpts
--- @field init any
--- @field args kvmult

--- @param tbl? table
--- @param reducer? function
--- @param opts? any | reduceOpts
--- @return any
function reduce(tbl, reducer, opts)
  if not tbl or #tbl == 0 then
    return nil
  end

  reducer = reducer or returnLarger

  if not type(opts) == "table" or isListOrEmptyTable(opts) then
    opts = {init = opts}
  else 
    opts = opts or {}
  end

  opts.init = opts.init or ""
  opts.args = opts.args or {"v"}

  local acc = opts.init
  for k, v in pairs(tbl) do
    local retriever = {
      k = k,
      v = v
    }
    local args = {}
    for _, arg in ipairs(opts.args) do
      table.insert(args, retriever[arg])
    end
    acc = reducer(acc, table.unpack(args))
  end
  return acc
end

