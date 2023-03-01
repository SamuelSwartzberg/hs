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

local extension_map = {
  ["jpeg"] = "jpg",
  ["htm"] = "html",
  ["yml"] = "yaml",
  ["markdown"] = "md"
}

--- will contain an empty string as the first element if path starts with a slash, which is what we want
--- @param path string
--- @return string[]
function getPathComponents(path)
  return pathSlice(path, ":") --[[ @as string[] ]]
end

--- @alias sliceOpts { ext_sep?: boolean, standartize_ext?: boolean, rejoin_at_end?: boolean, entire_path_for_each?: boolean }

--- @param path string
--- @param spec sliceSpec | string
--- @param opts? sliceOpts
--- @return string[] | string
function pathSlice(path, spec, opts)
  opts = tablex.deepcopy(opts) or {}
  local raw_path_components = stringy.split(path, "/")
  if raw_path_components[#raw_path_components] == "" then
    push(raw_path_components) -- if path ends with a slash, remove the empty string at the end
  end

  if opts.ext_sep then
    local leaf = push(raw_path_components)
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

    pop(raw_path_components, without_extension)
    pop(raw_path_components, extension)
  end

  local res =  slice(raw_path_components, spec)

  if opts.rejoin_at_end then 
    if opts.ext_sep then 
      local extension = push(res)
      if not extension then return "" end
      local without_extension = push(res)
      if without_extension == nil then -- in this case, we sliced everything but the last element
        return extension
      else
        local filename
        if extension == "" then
          filename = without_extension
        else
          filename = without_extension .. "." .. extension
        end
        if #res == 0 then
          return filename
        else
          return table.concat(res, "/") .. "/" .. filename
        end
      end
    else 
      return table.concat(res, "/")
    end
  elseif opts.entire_path_for_each then
    if opts.ext_sep then error("Getting entire path for each component when treating filename and extension as separate components is difficult and thus currently not supported") end
    for i = #res, 1, -1 do
      local relevant_path_components = slice(raw_path_components, { start = 1, stop = i })
      res[i] = table.concat(relevant_path_components, "/")
    end
  else
    return res
  end
end