
local in_one_s = os.time() + 1

doAtTimestamp(in_one_s, function()
  assertMessage(
    os.time(),
    in_one_s
  )
end)