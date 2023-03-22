--- @param opts? tableProcOpts | kvmult
function iterToTbl(opts, ...)
  local args = {...}
  if type(opts) == "function" then -- actually no opts
    table.insert(args, 1, opts)
    opts = nil
  end
  if not opts then opts = {ret = "kv"} 
  elseif type(opts) == "table" and not isListOrEmptyTable(opts) and not opts.ret then opts.ret = "kv" end 
  opts = defaultOpts(opts)

  local res = getEmptyResult(nil, opts)

  for a1, a2, a3, a4, a5, a6, a7, a8, a9 in table.unpack(args) do
    local as = {a1, a2, a3, a4, a5, a6, a7, a8, a9}
    inspPrint(as)
    addToRes(as, res, opts, nil, nil)
  end

  return res
end

function revipairs_iter(tbl, index)
  index = index - 1
  if index >= 1 then
      return index, tbl[index]
  end
end

function revipairs(tbl)
  return revipairs_iter, tbl, #tbl + 1
end
