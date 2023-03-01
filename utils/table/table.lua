





--- take an arbitrarily nested table and return a list of leaf values

---@param v any
---@return any[]
function collectLeaves(v)
  return map(v, collectLeaves, {flatten=true, tolist=true})
end
