

--- @generic T : string
--- @param list { [string]: any, [T]: table | nil}[]
--- @param path? string[]
--- @param specifier? { children_key_name?: `T`, title_key_name?: string, levels_of_nesting_to_skip?: number, include_inner_nodes?: boolean }
--- @return { path: any[], [any]: any}[]
function listWithChildrenKeyToListIncludingPath(list, path, specifier)
  if not path then path = {} end
  if not specifier then specifier = {} end
  if not specifier.children_key_name then specifier.children_key_name = "children" end
  if not specifier.title_key_name then specifier.title_key_name = "title" end
  if not specifier.levels_of_nesting_to_skip then specifier.levels_of_nesting_to_skip = 0 end
  local result = {}
  for i, item in iprs(list) do
    local cloned_path = copy(path, false)
    push(cloned_path, item[specifier.title_key_name])
    local children = item[specifier.children_key_name]
    if specifier.levels_of_nesting_to_skip > 0 and children then
      for i = 1, specifier.levels_of_nesting_to_skip do -- this is to handle cases in which instead of children being { item, item, ... }, it's {{ item, item, ... }} etc. Really, this shouldn't be necessary, but some of the data I'm working with is like that.
        children = children[1]
      end
    end
    if not isListOrEmptyTable(children) then children = nil end
    if specifier.include_inner_nodes or not children then -- if it doesn't have children (or we want to include inner nodes), add it to the result
      item.path = copy(path, false) -- not cloned_path as we want the path to be the path up to and including the parent, not the path up to and including the item. 
      item[specifier.children_key_name] = nil
      push(result, item)
    end
    if children then -- if it has children, recurse
      result = concat(result, listWithChildrenKeyToListIncludingPath(children, cloned_path, specifier))
    end
  end
  return result
end