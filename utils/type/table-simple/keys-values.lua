--- @generic K
--- @generic V
--- @param tbl { [`K`]: `V` } | nil
--- @return K[]
function keys(tbl)
  if tbl == nil then return {} end
  local t = {}
  for k, _ in pairs(tbl) do
    t[#t + 1] = k
  end
  return t
end

--- @generic K
--- @generic V
--- @param tbl { [`K`]: `V` } | nil
--- @return K[]
function ks(tbl)
  if tbl == nil then return {} end
  local t = {}
  for k, _ in prs(tbl) do
    t[#t + 1] = k
  end
  return t
end


--- @generic K
--- @generic V
--- @param tbl { [`K`]: `V` } | nil
--- @return V[]
function values(tbl)
  if tbl == nil then return {} end
  local t = {}
  for _, v in pairs(tbl) do
    t[#t + 1] = v
  end
  return t
end

--- @generic K
--- @generic V
--- @param tbl { [`K`]: `V` } | nil
--- @return V[]
function vls(tbl)
  if tbl == nil then return {} end
  local t = {}
  for _, v in prs(tbl) do
    t[#t + 1] = v
  end
  return t
end