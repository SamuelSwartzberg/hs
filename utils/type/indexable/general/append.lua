---@class appendOpts
---@field nooverwrite? boolean

---add a single element to an indexable
---@generic T : indexable
---@param base `T`
---@param addition any
---@param opts? appendOpts
---@return T
function append(base, addition, opts)
  opts = opts or {}
  if type(base) == "string" then
    if not base then base = "" end
    if not addition then return base end
    return base .. addition
  elseif type(base) == "table" then
    local new_thing = tablex.deepcopy(base) 
    if not addition then return new_thing end
    if isListOrEmptyTable(base) then
      new_thing[#new_thing + 1] = addition
      return new_thing
    else
      if base.isassoc == "isassoc" then base.isassoc = nil end
      if #values(addition) >= 2 then
        if not opts.nooverwrite or not new_thing[addition[1]] then
          new_thing[addition[1]] = addition[2]
        end
        return new_thing
      else
        error("can't append a non-pair to an assoc arr")
      end
    end
  else
    error("append only works on strings, lists, and tables. got " .. type(base) .. " when processing:\n\n" .. json.encode(base))
  end
end