
--- iprs dropin replacement that supports start/stop/step and works with any indexable
--- guarantees the same order every time, and typically also the same order as ipairs (though this is not guaranteed)
--- @param thing indexable
--- @param start? integer
--- @param stop? integer
--- @param step? integer
--- @param limit? integer limit the number of iterations, regardless of the index
--- @return function, indexable, integer
function iprs(thing, start, stop, step, limit)
  local len_thing = len(thing)
  if len_thing == 0 then
    return function() end, thing, 0
  end
  start = start or 1 -- default to first elem
  if start < 0 then -- if negative, count from the end
    start = len_thing + start + 1 -- e.g. 8 + -1 + 1 = 8 -> last elem
  end
  stop = stop or len_thing -- default to last elem
  if stop < 0 then -- if negative, count from the end
    stop = len_thing + stop + 1
  end
  step = step or 1
  limit = limit or math.huge
  local iters = 0
  if (start - stop) * (step/math.abs(step)) > 0 then
    start, stop = stop, start -- swap if they're in the wrong order
  end
  return function(thing, i)
    i = i + step
    iters = iters + 1
    if 
      ((step > 0 and i <= stop) or
      (step < 0 and i >= stop)) and
      iters <= limit
    then
      return i, elemAt(thing, i)
    end
  end, thing, start - step
end

--- @param thing indexable
--- @param start? integer
--- @param stop? integer
--- @param step? integer
--- @param limit? integer
--- @return function, indexable, integer
function reviprs(thing, start, stop, step, limit)
  return iprs(thing, start, stop, step and -math.abs(step) or -1, limit)
end

--- pairs dropin replacement that is ordered by default, supports start/stop/step and works with any indexable
--- difference from iprs is that it returns the key instead of the index
--- in case of a list/string, the key is the index, so it's the same as iprs
--- guarantees the same order every time, thus may have a different order than pairs
--- @param thing indexable
--- @param start? integer
--- @param stop? integer
--- @param step? integer
--- @param limit? integer
--- @return function, indexable, integer
function prs(thing, start, stop, step, limit)
  local iter, tbl, idx = iprs(thing, start, stop, step, limit)
  return function(tbl)
    local i, v = iter(tbl, idx)
    if i then
      idx = i
      return table.unpack(elemAt(thing, i, "kv"))
    end
  end, tbl, idx
end

--- @param thing indexable
--- @param start? integer
--- @param stop? integer
--- @param step? integer
--- @param limit? integer
--- @return function, indexable, integer
function revprs(thing, start, stop, step, limit)
  return prs(thing, start, stop, step and -math.abs(step) or -1, limit)
end

--- @param opts? tableProcOpts | kvmult
function iterToTbl(opts, ...)
  local args = {...}
  if type(opts) == "function" then -- actually no opts
    table.insert(args, 1, opts)
    opts = nil
  end
  opts = defaultOpts(opts, "kv")

  local res = getEmptyResult({}, opts)

  for a1, a2, a3, a4, a5, a6, a7, a8, a9 in table.unpack(args) do
    local as = {a1, a2, a3, a4, a5, a6, a7, a8, a9}
    addToRes(as, res, opts, nil, nil)
  end

  return res
end

