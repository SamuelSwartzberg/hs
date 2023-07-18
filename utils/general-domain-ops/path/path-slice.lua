
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

  -- set defaults

  spec = spec or { start = -1, stop = -1}
  opts = get.table.copy(opts) or {}

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
      dothis.array.pop(raw_path_components) -- remove the empty string at the end
    end
  end

  -- slice

  local res, eff_slice_spec =  memoize(
    slice, 
    refstore.params.memoize.opts.stringify_json
  )(raw_path_components, spec)
  local same_start_elem = res[1] == raw_path_components[1]
  local starts_at_beginning = eff_slice_spec.start == 1
    
  local still_starts_at_root = started_with_slash and same_start_elem and starts_at_beginning

  -- handle postprocessing

  if opts.rejoin_at_end then 
    if still_starts_at_root then
      table.insert(res, 1, "") -- if we started with a slash, we need to reinsert an empty string at the beginning so that it will start with a slash again once we rejoin
    end
    if opts.ext_sep then -- if we separated the path into filename and extension, we need to rejoin them
      local extension = dothis.array.pop(res)
      if not extension then return "" end
      local without_extension = dothis.array.pop(res)
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
    
  else
    return res
  end
end