---@param application_name string|hs.application
---@return RootComponentInterface
function getMenuItemList(application_name)
  local application
  if type(application_name) == "string" then
    application = hs.application.get(application_name)
  else
    application = application_name
  end
  local flattened = listWithChildrenKeyToListIncludingPath(application:getMenuItems(), {}, { title_key_name = "AXTitle", children_key_name = "AXChildren", levels_of_nesting_to_skip = 1 })
  local filtered = filter(flattened, function (v) return v.AXTitle ~= "" end)
  for k, v in prs(filtered) do
    v.application = application
  end
  local mapped_to_items = map(filtered, function (v) return CreateTable(v) end)
  local res =  CreateArray(mapped_to_items)
  return res
end