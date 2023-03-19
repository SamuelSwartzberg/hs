--- @class splitOpts
--- @field mode? "remove" | "before" | "after" whether to remove the separator, or split before or after it, keeping the separator
--- @field findopts? findOptsWShorthand since the separator is a conditionSpec passed to find, you can pass options to find here

--- split an indexable into a list of indexables, using a conditionSpec as a separator
--- @generic T : indexable
--- @param thing T
--- @param sep conditionSpec
--- @param opts? splitOpts
--- @return T[], T[]?
function split(thing, sep, opts)
  opts = tablex.deepcopy(opts) or {}
  local splintervals = find(
    thing,
    sep,
    {
      ret = "kv",
      findall = true
    }
  )

  if len(splintervals) <= 1 then
    return {thing}
  end

  local res = {}
  local removed = {}
  local lastend = 1
  for _, pair in ipairs(splintervals) do
    local start, match = table.unpack(pair)
    local matchlength 
    if type(match) == "string" then
      matchlength = len(match)
    else
      matchlength = 1
    end
    local sliceend = start - 1
    if opts.mode == "after" then
      sliceend = sliceend + matchlength
    end
    local fragment = slice(thing, lastend, sliceend)
    push(res, fragment)
    local stop = start + matchlength - 1
    lastend = stop + 1
    if opts.mode == "before" then
      lastend = lastend - matchlength
    end
    if opts.mode == "remove" then
      push(removed, {start, slice(thing, start, stop)})
    end
  end

  local lastfragment = slice(thing, lastend)
  push(res, lastfragment)

  return res, removed
end