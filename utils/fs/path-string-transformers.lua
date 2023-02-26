--- @param str string
--- @return string | nil
function getExtension(str)
  return pathSlice(str, "-1:-1", { ext_sep = true })[1]
end

--- @param str string
--- @return string | nil
function getFilenameWithoutExtension(str)
  return pathSlice(str, "-2:-2", { ext_sep = true })[1]
end

--- @param path string
--- @return string
function getPathWithoutExtension(path)
  return pathSlice(path, ":-2", { ext_sep = true, rejoin_at_end = true }) --[[ @as string]]
end


--- @param str string
--- @return string
function getLeafWithoutPath(str)
  return pathSlice(str, "-1:-1")[1]
end

--- @param str string
--- @return string | nil
function getLeafWithoutPathOrExtension(str)
  return pathSlice(str, "-2:-2", { ext_sep = true })[1]
end



--- @param path string
--- @return string
function getParentPath(path)
  return pathSlice(path, ":-2", { rejoin_at_end = true }) --[[ @as string ]]
end

--- @param path string
--- @return string
function getParentDirname(path)
  return pathSlice(path, "-2:-2")[1]
end

--- @param path string
--- @return string
function getGrandparentPath(path)
  return pathSlice(path, ":-3", { rejoin_at_end = true }) --[[ @as string ]]
end

local rrq = bindArg(relative_require, "utils.fs")
local extension_map = rrq("extension-map")


--- @param str string
--- @return string
function getStandartizedExtension(str)
  return pathSlice(str, "-1:-1", { ext_sep = true, standartize_ext = true })[1]
end

--- will contain an empty string as the first element if path starts with a slash, which is what we want
--- @param path string
--- @return string[]
function getPathComponents(path)
  return pathSlice(path, ":") --[[ @as string[] ]]
end

--- @param path string
--- @param spec sliceSpec | string
--- @param opts? { ext_sep?: boolean, standartize_ext?: boolean, rejoin_at_end?: boolean }
--- @return string[] | string
function pathSlice(path, spec, opts)
  opts = opts or {}
  local raw_path_components = stringy.split(path, "/")
  if raw_path_components[#raw_path_components] == "" then
    listPop(raw_path_components) -- if path ends with a slash, remove the empty string at the end
  end

  if opts.ext_sep then
    local leaf = listPop(raw_path_components)
    local without_extension = ""
    local extension = ""
    if leaf == "" then
      -- already both empty, nothing to do
    elseif stringy.startswith(leaf, ".") then -- dotfile
      without_extension = leaf
    elseif stringy.endswith(leaf, ".") then -- file that ends with a dot, does not count as having an extension
      without_extension = leaf
    elseif not stringy.find(leaf, ".") then
      without_extension = leaf
    else -- in case of multiple dots, everything after the last dot is considered the extension
      without_extension, extension = leaf:match("^(.+)%.([^%.]+)$")
    end

    if opts.standartize_ext then
      extension = extension_map[extension] or extension
    end

    listPush(raw_path_components, without_extension)
    listPush(raw_path_components, extension)
  end

  local res =  slice(raw_path_components, spec)

  if opts.rejoin_at_end then 
    if opts.ext_sep then 
      local without_extension = listPop(res)
      local extension = listPop(res)
      if extension == "" then
        return table.concat(res, "/") .. "/" .. without_extension
      else
        return table.concat(res, "/") .. "/" .. without_extension .. "." .. extension
      end
    else 
      return table.concat(res, "/")
    end
  else
    return res
  end
end