--- @class prefixOpts
--- @field rev boolean whether to search for the prefix in reverse (ergo will return the suffix, but in the original order)

--- find the longest common prefix of a list of indexables
--- @generic T : indexable
--- @param list `T`[]
--- @param opts? prefixOpts
--- @return T
function longestCommonPrefix(list, opts)
  opts = copy(opts) or {}
  if opts.rev then
    list = map(list, rev)
  end

  local res = reduce(list, function(acc, thing)
    local isstring =type(thing) == "string"
    local last_matching_index = 0
    for i = 1, len(thing) do
      if elemAt(thing, i) == elemAt(acc, i) then
        last_matching_index = i
      else
        break
      end
    end

    return slice(acc, 1, last_matching_index) or ( isstring and "" or {} )
  end, list[1])

  if opts.rev then
    res = rev(res)
  end

  return res
end