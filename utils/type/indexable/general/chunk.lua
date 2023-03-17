--- @generic T : indexable
--- @param thing T
--- @param n integer
--- @return T[]
function chunk(thing, n)
  return split(thing, function(k) return (k - 1) % n == 0 end, { includesep = true , findopts = { args = "k"} })
end
