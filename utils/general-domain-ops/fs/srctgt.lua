

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

  -- check if path is remote, customize things accordingly

  local has_remote_path = source_is_remote or target_is_remote

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
      if action == "link" then
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
    dothis.extant_path.copy_to_absolute_path(tmptarget, final_target)
    dothis.absolute_path.delete
  end
end
