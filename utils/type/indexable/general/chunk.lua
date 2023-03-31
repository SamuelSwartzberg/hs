--- Split an indexable into chunks of a given size.
--- @generic T : indexable
--- @param thing T
--- @param n integer
--- @return T[]
function chunk(thing, n)
  return split(
    thing, 
    function(k) 
      print(k)
      return k % n == 0 
    end, 
    { mode = "after" , findopts = { args = "i"} }
  )
end
