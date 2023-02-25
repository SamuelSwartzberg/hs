

---@param subj string
---@param patt string|userdata
---@param init? number
---@param cf? number|string
---@param ef? number
---@param ... any
---@return (string|boolean)...
function onigMatch(subj, patt, init, cf, ef, ...)
  return onig.match(subj, patt, init, cf, ef, ...)
end