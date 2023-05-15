function hsInspectCleaned(value, depth)
  if type(value) == "table" then
    value = map(value, function (v)
      if type(v) == "number" and v % 1 == 0 then
        return math.floor(v)
      else
        return v
      end
    end, { recurse = true, args = "v", ret = "v" })
  elseif type(value) == "number" and value % 1 == 0 then
    value = math.floor(value)
  end
  return hs.inspect(value, {
    depth = depth or 2
  })

end

--- @param value any
--- @param depth? integer
--- @return nil
function inspPrint(value, depth)
  depth = depth or 2
  print(hsInspectCleaned(value, depth))
end