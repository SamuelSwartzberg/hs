--- @param name? string 
--- @param all? boolean
--- @return string
function hsPasteboardReadString(name, all)
  if all == nil then all = false end
  return hs.pasteboard.readString(name, all)
end