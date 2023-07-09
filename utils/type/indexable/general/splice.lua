--- @class spliceOpts : appendOpts
--- @field start? integer
--- @field overwrite? boolean

--- @generic T : indexable
--- @param thing1 T
--- @param thing2 T
--- @param opts? spliceOpts | integer
--- @return T
function splice(thing1, thing2, opts)
  if type(opts) == "number" then
    opts = {start = opts}
  else
    opts = get.table.copy(opts) or {}
  end
  opts.start = opts.start or 1
  opts.overwrite = get.any.default_if_nil(opts.overwrite, false)
  local res = {}
  local before = slice(thing1, 1, opts.start - 1)
  if opts.overwrite then
    local after = slice(thing1, opts.start + len(thing2))
    res = concat(before, thing2, after)
  else
    local after = slice(thing1, opts.start)
    res = concat(before, thing2, after)
  end
  return res
end