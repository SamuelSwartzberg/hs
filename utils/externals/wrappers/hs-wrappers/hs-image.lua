--- any function that is wrapped automatically exists as a memoized version, which is the rationale for wrapping that serves no other purpose

--- @param bundleID string
--- @return hs.image
function imageFromAppBundle(bundleID)
  return hs.image.imageFromAppBundle(bundleID)
end

--- @param path string
--- @return hs.image
function imageFromPath(path)
  return hs.image.imageFromPath(path)
end