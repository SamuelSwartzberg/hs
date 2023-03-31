--- Split an indexable into chunks of a given size.
--- @generic T : indexable
--- @param thing T
--- @param n integer
--- @return T[]
function chunk(thing, n)
  local chunks = split(
    thing, 
    function(k) 
      print(k)
      return k % n == 0 
    end, 
    { mode = "after" , findopts = { args = "i"} }
  )
  if len(chunks[#chunks]) == 0 then -- if the last chunk is empty, remove it
    chunks[#chunks] = nil
  end
  return chunks
end
