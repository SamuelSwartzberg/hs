---@param str string
---@param base string
---@return string
function fromBaseEncoding(str, base)
  return basexx["from_" .. base](str)
end

---@param str string
---@param base string
---@return string
function toBaseEncoding(str, base)
  return basexx["to_" .. base](str)
end