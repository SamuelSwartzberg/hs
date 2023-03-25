
--- @param value any
--- @param depth? integer
--- @return nil
function inspPrint(value, depth)
  depth = depth or 2
  print(hs.inspect(value, {depth = depth}))
end


