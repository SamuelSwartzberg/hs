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
  print("---split---")
  opts = copy(opts) or {}
  local splintervals = find(
    thing,
    sep,
    concat({
      ret = "iv",
      findall = true
    }, opts.findopts)
  )

  if len(splintervals) == 0 then
    return {thing}
  end

  inspPrint(splintervals)

  local res = {}
  local removed = {}
  local lastend = 1
  for _, pair in iprs(splintervals) do
    local start, match = table.unpack(pair)
    local matchlength 
    if type(thing) == "string" then -- we're splitting a string, so splitter can have variable length in relation to the thing
      matchlength = len(match)
    else
      matchlength = 1
    end
    local sliceend = start - 1
    if opts.mode == "after" then
      sliceend = sliceend + matchlength
    end
    inspPrint(thing)
    print(lastend, sliceend)
    local fragment = slice(thing, lastend, sliceend)
    inspPrint(fragment)
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
  inspPrint(lastend)
  print("lastfrag")
  inspPrint(lastfragment)
  push(res, lastfragment) -- TODO: not checking if lastfragment is empty might cause problems, but checking definitely causees problems. If problems occur, more complex logic is needed here

  return res, removed
end