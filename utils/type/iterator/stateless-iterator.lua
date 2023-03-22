-- sliceable ipairs & revipairs

function ipairs(tbl, start, stop)
  start = start or 1
  stop = stop or #tbl
  local i = start - 1
  return function()
    i = i + 1
    if i <= stop then
      return i, tbl[i]
    end
  end, tbl, start
end

function revipairs(tbl, stop, start)
  start = start or #tbl
  stop = stop or 1
  local i = start + 1
  return function()
    i = i - 1
    if i >= stop then
      return i, tbl[i]
    end
  end, tbl, start
end

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
    addToRes(as, res, opts, nil, nil)
  end

  return res
end

