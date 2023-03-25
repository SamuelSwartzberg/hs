--- @generic K
--- @generic V
--- @param tbl { [`K`]: `V` } | nil
--- @return K[]
function keys(tbl)
  local t = {}
  for k, _ in wdefarg(pairs)(tbl) do
    t[#t + 1] = k
  end
  return t
end

--- @generic K
--- @generic V
--- @param tbl { [`K`]: `V` } | nil
--- @return K[]
function ks(tbl)
  local t = {}
  for k, _ in wdefarg(prs)(tbl) do
    inspPrint(k)
    t[#t + 1] = k
  end
  return t
end


--- @generic K
--- @generic V
--- @param tbl { [`K`]: `V` } | nil
--- @return V[]
function values(tbl)
  local t = {}
  for _, v in wdefarg(pairs)(tbl) do
    t[#t + 1] = v
  end
  return t
end

--- @generic K
--- @generic V
--- @param tbl { [`K`]: `V` } | nil
--- @return V[]
function vls(tbl)
  local t = {}
  for _, v in wdefarg(prs)(tbl) do
    t[#t + 1] = v
  end
  return t
end