
--- @alias sliceOpts { ext_sep?: boolean, standartize_ext?: boolean, rejoin_at_end?: boolean, entire_path_for_each?: boolean }

--- @param path string
--- @param spec? sliceSpec | string
--- @param opts? sliceOpts
--- @return string[] | string
function pathSlice(path, spec, opts)

  -- set defaults

  spec = spec or { start = -1, stop = -1}
  opts = tablex.deepcopy(opts) or {}

  -- prepare path components

  local raw_path_components = stringy.split(path, "/")
  if raw_path_components[#raw_path_components] == "" then
    pop(raw_path_components) -- if path ends with a slash, remove the empty string at the end
  end

  -- handle special case of also slicing the extension

  if opts.ext_sep then
    local leaf = pop(raw_path_components)
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
      extension = processors.normalizers.extension[extension] or extension
    end

    push(raw_path_components, without_extension)
    push(raw_path_components, extension)
  end

  -- slice

  local res =  slice(raw_path_components, spec)

  -- handle postprocessing

  if opts.rejoin_at_end then 
    if opts.ext_sep then 
      local extension = pop(res)
      if not extension then return "" end
      local without_extension = pop(res)
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