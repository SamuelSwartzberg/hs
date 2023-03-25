
--- iprs dropin replacement that supports start/stop/step and works with any indexable
--- @param thing indexable
--- @param start? integer
--- @param stop? integer
--- @param step? integer
--- @return function, indexable, integer
function iprs(thing, start, stop, step)
  start = start or 1
  stop = stop or len(thing)
  step = step or 1
  if (start - stop) * (step/math.abs(step)) > 0 then
    start, stop = stop, start -- swap if they're in the wrong order
  end
  local i = start
  return function()
    if 
      (step > 0 and i >= stop) or
      (step < 0 and i <= stop)
    then
      return i, elemAt(thing, i)
    end
    i = i + step
  end, thing, start
end

--- @param thing indexable
--- @param start? integer
--- @param stop? integer
--- @param step? integer
--- @return function, indexable, integer
function reviprs(thing, start, stop, step)
  return iprs(thing, start, stop, step and -math.abs(step) or -1)
end

--- pairs dropin replacement that is ordered by default, supports start/stop/step and works with any indexable
--- difference from iprs is that it returns the key instead of the index
--- in case of a list/string, the key is the index, so it's the same as iprs
--- @param thing indexable
--- @param start? integer
--- @param stop? integer
--- @param step? integer
--- @return function, indexable, integer
function prs(thing, start, stop, step)
  local iter, tbl, state = iprs(thing, start, stop, step)
  return function()
    local i, v = iter(tbl, state)
    if i then
      return table.unpack(elemAt(thing, i, "kv"))
    end
  end, tbl, state
end

--- @param thing indexable
--- @param start? integer
--- @param stop? integer
--- @param step? integer
--- @return function, indexable, integer
function revprs(thing, start, stop, step)
  return prs(thing, start, stop, step and -math.abs(step) or -1)
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

