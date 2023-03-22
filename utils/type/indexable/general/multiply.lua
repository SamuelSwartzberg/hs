--- concat an indexable to itself n times
--- @generic T : indexable
--- @param thing T
--- @param n integer
--- @param opts? concatOpts
--- @return T
function multiply(thing, n, opts)
  local newthing = thing
  for i = 1, n-1 do
    newthing = concat(newthing, thing, opts)
  end
  return newthing
end