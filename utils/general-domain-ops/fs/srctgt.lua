

--- @param action "copy" | "move" | "link" | "zip" what to do with the source
--- @param source string the source file or directory. May be local, rclone remote, or a URL
--- @param target string  the target file or directory. May be local or rclone remote
--- @param condition? "exists" | "not-exists" | "any" when, related to the existence of the target, to action the source
--- @param create_path? boolean whether to create the path of the target if it doesn't exist
--- @param into? boolean whether to action the source into the target directory, rather than action the source to the target
--- @param all_in? boolean whether to action all the files in the source directory, rather than the source directory itself
--- @param relative_to? string allow specifying a root directory to resolve relative paths from 
--- @return nil
function srctgt(action, source, target, condition, create_path, into, all_in, relative_to)

  -- set defaults

  condition = get.any.default_if_nil(condition, "any")
  create_path = get.any.default_if_nil(create_path, true)
  into = get.any.default_if_nil(into, false)
  all_in = get.any.default_if_nil(all_in, false)
  target = get.any.default_if_nil(target, source .. "." .. action)

  local source_is_url = isUrl(source)

  if source_is_url then
    if action == "move" or action == "link" then
      error("cannot " .. action .. " a URL")
    end
    if all_in then
      error("cannot action all_in a URL, as listing the contents of a URL cannot reliably be done")
    end
    local url = source
    source = transf.url.in_cache_dir(url)
    run("curl -L " .. transf.string.single_quoted_escaped(url) .. " -o " .. transf.string.single_quoted_escaped(source))
  end

  -- resolve tilde

  source = hs.fs.pathToAbsolute(source, true)
  target = hs.fs.pathToAbsolute(target, true)

  -- check if path is remote, customize things accordingly

  local source_is_remote = is.path.remote_path(source)
  local target_is_remote = is.path.remote_path(target)
  local has_remote_path = source_is_remote or target_is_remote

  -- resolve relative_to

  if relative_to then
    source, target = resolve({
      s = {
        path = source,
        root = relative_to,
      },
      t = {
        prefix = is.path.remote_path(target) and "hsftp:" or nil
      }
    })
  end

  -- create (parent) path if necessary

  if create_path then
    if is.absolute_path.dir(target) or into then
      dothis.absolute_path.create_dir(target)
    else
      dothis.absolute_path.create_dir(target, "1:-2")
    end
  end

  -- check if target exists, and if return early if it does not match the condition

  if is.path.extant_path(target) then
    if condition == "not-exists" then
      return nil
    end
  else
    if condition == "exists" then
      return nil
    end
  end

  -- if into, then change target to be the target directory + the leaf of the source

  if into then
    if not is.absolute_path.dir(target) then
      error("target must be a directory if into is true. Target: " .. target)
    end
    target = target .. "/" .. transf.path.leaf(source)
    dothis.absolute_path.create_dir(target, "1:-2")
  end

  -- prepare a list of sources to action, or a 'list' of one if not all_in

  local sources
  if all_in then
    sources = transf.dir.children_absolute_path_array(source)
  else
    sources = {source}
  end

  local final_target = target
  local tmptarget 
  for _, final_source in transf.array.index_value_stateless_iter(sources) do    
    -- if all_in, then change target to be the target directory + the leaf of the source
    -- this does mean that this doesn't play nice with the `into` option, but I don't think that's a problem
    if all_in then
      final_target = target .. "/" .. transf.path.leaf(final_source)
      dothis.absolute_path.create_dir(final_target, "1:-2")
    end

    if not has_remote_path then 
      if action == "copy" then
        if is.absolute_path.dir(final_source) then
          _, err_msg =  dir.clonetree(final_source, final_target)
        else
          _, err_msg  =  file.copy(final_source, final_target)
        end
      elseif action == "move" then
        _, err_msg =  os.rename(final_source, final_target)
      elseif action == "link" then
        _, err_msg =  hs.fs.link(final_source, final_target, true)
      elseif action == "zip" then
        run({
          "zip",
          "-r",
          { value = final_target, type = "quoted"},
          { value = final_source, type = "quoted"}
        })
      end
    else
      if action == "copy" then
        run({
          "rclone",
          "copyto",
          { value = final_source, type = "quoted"},
          { value = final_target, type = "quoted"}
        })
      elseif action == "move" then
        run({
          "rclone",
          "moveto",
          { value = final_source, type = "quoted"},
          { value = final_target, type = "quoted"}
        })
      elseif action == "link" then
        error("linking remote files is not supported (not supported by rclone and also not really sensible)")
      elseif action == "zip" then
        tmptarget = env.TMPDIR .. "/" .. os.time() .. "-" .. transf.int.random_int_of_length(8) .. ".zip"
        run({
          "zip",
          "-r",
          { value = tmptarget, type = "quoted"},
          { value = final_source, type = "quoted"}
        })
      end

    end

    if err_msg then
      error(err_msg)
    end
  end

  -- finalize actions that could not be performed in the loop

  if tmptarget then
    srctgt("copy", tmptarget, final_target)
    dothis.absolute_path.delete
  end
end
