--- @param str string
--- @return string | nil
function getExtension(str)
  local _, extension = getFilenameParts(str)
  return extension
end

--- @param str string
--- @return string | nil
function getFilenameWithoutExtension(str)
  local without_extension, _ = getFilenameParts(str)
  return without_extension
end

--- @param path string
--- @return string
function getPathWithoutExtension(path)
  local path_components = stringy.split(path, "/")
  local leaf = listPop(path_components)
  local leaf_without_extension = getFilenameWithoutExtension(leaf)
  table.insert(path_components, leaf_without_extension)
  return table.concat(path_components, "/")
end


--- @param str string
--- @return string
function getLeafWithoutPath(str)
  local leaf = str:match("^.*/([^/]*)$")
  if leaf == nil then
    return str
  else
    return leaf
  end
end

--- @param str string
--- @return string | nil
function getLeafWithoutPathOrExtension(str)
  local filename = getLeafWithoutPath(str)
  return getFilenameWithoutExtension(filename)
end

--- will contain an empty string as the first element if path starts with a slash, which is what we want
--- @param path string
--- @return string[]
function getPathComponents(path)
  local raw_path_components = stringy.split(path, "/")
  if raw_path_components[#raw_path_components] == "" then
    listPop(raw_path_components) -- if path ends with a slash, remove the empty string at the end
  end
  return raw_path_components
end

--- @param path string
--- @return string
function getParentPath(path)
  local path_components = getPathComponents(path)
  local _ = listPop(path_components)
  local res = table.concat(path_components, "/")
  if res == "" then
    return "/"
  else
    return res
  end
end

--- @param path string
--- @return string
function getParentDirname(path)
  local raw_path_components = getPathComponents(path)
  return raw_path_components[#raw_path_components - 1] or "/"
end

--- @param path string
--- @return string
function getGrandparentPath(path)
  return getParentPath(getParentPath(path))
end

local rrq = bindArg(relative_require, "utils.fs")
local extension_map = rrq("extension-map")


--- @param str string
--- @return string | nil
function getStandartizedExtension(str)
  if not str then return nil end
  str = str:lower()
  local extension = getExtension(str)
  if extension_map[extension] then
    return extension_map[extension]
  else
    return extension
  end
end

---@param str string
---@return string | nil, string | nil
function getFilenameParts(str)
  local without_extension, extension
  if str == nil or str == "" then
    return nil, nil
  elseif stringy.startswith(str, ".") then -- dotfile
    without_extension = str
  elseif stringy.endswith(str, ".") then -- file that ends with a dot, does not count as having an extension
    without_extension = str
  elseif not stringy.find(str, ".") then
    without_extension = str
  else -- in case of multiple dots, everything after the last dot is considered the extension
    without_extension, extension = str:match("^(.+)%.([^%.]+)$")
  end
  return without_extension, extension
end
