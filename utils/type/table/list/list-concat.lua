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

--- @generic T, U
--- @param ... T[] | T | nil
--- @return (T | U)[]
function listConcat(...)
  local new_list = {}
  for _, list in ipairs({...}) do
    addValuesToList(new_list, list)
  end
  return new_list
end