

local loop_counters = {}

function preventInfiniteLoop(identifier, tries)
  if not loop_counters[identifier] then
    loop_counters[identifier] = 0
  end
  loop_counters[identifier] = loop_counters[identifier] + 1
  if loop_counters[identifier] > tries then
    error(("Infinite loop detected in %s"):format(identifier))
  end
end


--- @param value any
--- @param depth? integer
--- @return nil
function inspPrint(value, depth)
  print(hs.inspect(value, {
    depth = depth or 2
  }))
end