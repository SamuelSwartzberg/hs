--- @generic T, U
--- @param list T[] | nil
--- @param values U[] | U
--- @return nil
local function addValuesToList(list, values)
  if not list then list = {} end
  if type(values) == "nil" then
    -- do nothing
  elseif not isListOrEmptyTable(values) then
    list[#list + 1] = values
  else
    for _, v in ipairs(values) do
      list[#list + 1] = v
    end
  end
end

--- @class concatOpts
--- @field isopts "isopts"
--- @field sep? any

--- @generic T, U
--- @param ... T[] | T | nil
--- @return (T | U)[]
function listConcat(...)
  local lists = {...}
  if not opts then return {} end
  if type(opts) == "table" and opts.isopts == "isopts" then
    -- no-op
  else -- opts is actually the first list
    table.insert(lists, 1, opts)
    opts = {}
  end

  local new_list = {}
  for _, list in ipairs(lists) do
    addValuesToList(new_list, list)
    if opts.sep then
      addValuesToList(new_list, opts.sep)
    end
  end
  return new_list
end