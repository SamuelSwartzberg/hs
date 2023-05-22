
--- @class pathSliceOpts 
--- @field ext_sep? boolean whether to treat the extension as a separate component. This is guaranteed to guarantee two elements, even when either the extension or the non-extension part of the leaf of the path is empty (Empty components will be ""), thus allowing predictable indexing of the result. Default nil (no extension separation)
--- @field standartize_ext? boolean whether to standartize the extension (e.g. "yml" -> "yaml") Default nil (no standartization)
--- @field rejoin_at_end? boolean whether to rejoin the path components at the end, thus returning a `string` instead of a `string[]`. Default nil (do not rejoin)
--- @field entire_path_for_each? boolean whether to return the entire path up to that component for each component. Default nil (do not return the entire path for each component). Cannot be set if `rejoin_at_end` is set. Example: pathSlice("/a/b/c", "1:-1", { entire_path_for_each = true }) -> { "/a", "/a/b", "/a/b/c" }

--- slices a path into components.
--- pathSlice("/a/b/c", ":") -> { "a", "b", "c" }
--- @param path string
--- @param spec? sliceSpecLike
--- @param opts? pathSliceOpts
--- @return string[] | string
function pathSlice(path, spec, opts)

  -- check path type

  if type(path) ~= "string" then
    error("pathSlice: path must be a string. Was " .. type(path))
  end

  -- set defaults

  spec = spec or { start = -1, stop = -1}
  opts = copy(opts) or {}

  -- set special state booleans

  local started_with_slash = stringy.startswith(path, "/")
  local ended_with_slash = stringy.endswith(path, "/")
  local path_is_just_a_slash = path == "/"
  local path_is_empty = path == ""

  -- prepare path components

  local raw_path_components = stringy.split(path, "/")

  -- handle various path edge cases

  if path_is_just_a_slash then
    raw_path_components = {"/"}
  elseif path_is_empty then
    if opts.ext_sep then
      raw_path_components = {"", ""}
    else
      raw_path_components = {""}
    end
  else 
    if started_with_slash then
      table.remove(raw_path_components, 1) -- remove the empty string at the beginning
    end
    if ended_with_slash then
      pop(raw_path_components) -- remove the empty string at the end
    end
  end

  -- handle special case of also slicing the extension
  -- both relevant if we want to actually separate the extension or if we want to standartize it
  if (opts.ext_sep or opts.standartize_ext) and not path_is_empty then
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
      without_extension, extension = eutf8.match(leaf, whole(mt._r_lua.without_extension_and_extension))
    end

    if opts.standartize_ext then
      extension = normalize.extension[extension] or extension
    end

    if opts.ext_sep then
      push(raw_path_components, without_extension)
      push(raw_path_components, extension)
    else
      push(raw_path_components, without_extension .. "." .. extension)
    end
  end

  -- slice

  inspPrint(raw_path_components)
  inspPrint(spec)
  inspPrint({slice(raw_path_components, spec)})
  local res, eff_slice_spec =  memoize(
    slice, 
    {stringify_table_params = true, table_param_subset = "json"}
  )(raw_path_components, spec)
  inspPrint(res)
  inspPrint(eff_slice_spec)
  local same_start_elem = res[1] == raw_path_components[1]
  local starts_at_beginning = eff_slice_spec.start == 1
    
  local still_starts_at_root = started_with_slash and same_start_elem and starts_at_beginning

  -- handle postprocessing

  if opts.rejoin_at_end then 
    if still_starts_at_root then
      table.insert(res, 1, "") -- if we started with a slash, we need to reinsert an empty string at the beginning so that it will start with a slash again once we rejoin
    end
    if opts.ext_sep then -- if we separated the path into filename and extension, we need to rejoin them
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
    for i, v in ipairs(res) do
      for rawi, rawv in ipairs(raw_path_components) do
        if rawv == v then
          local relevant_path_components = slice(raw_path_components, { start = 1, stop = rawi })
          if started_with_slash then
            table.insert(relevant_path_components, 1, "") -- if we started with a slash, we need to reinsert an empty string at the beginning so that it will start with a slash again once we rejoin
          end
          res[i] = table.concat(relevant_path_components, "/")
          break
        end
      end
    end
    return res
  else
    return res
  end
end