--- @generic T : indexable
--- @param thing T
--- @param n integer
--- @param opts? concatOpts
--- @return T
function multiply(thing, n, opts)
  local newthing = {}
  for i = 1, n do
    newthing = concat(newthing, thing, opts)
  end
  return newthing
end