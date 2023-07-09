function createDeterminantMetatableCreator(key)
  return function(tbl)
    local metatbl = {
        __index = {
        }
    }
    metatbl.__index["is" .. key] = true
    setmetatable(tbl, metatbl)
    return tbl
  end
end

array = createDeterminantMetatableCreator("list")
assoc = createDeterminantMetatableCreator("assoc")

pt = createDeterminantMetatableCreator("prompttbl")