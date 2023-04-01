---syncs files to and from the remote server using rclone
---@param path string the path, relative to the home directory on local and to the root directory on remote
---@param push_or_pull "push"|"pull"
---@param action? "copy" | "move"
---@param sync? boolean whether to do the action sync or async. Default false (async)
---@return nil
function syncHomeRelativePath(path, push_or_pull, action, sync)
  --- @type true | nil
  local final_run_param = true
  if sync then final_run_param = nil end
 
  local local_path = resolve(path)
  local remote_path = remote(path)
  local source, dest 
  if push_or_pull == "push" then
    source = local_path
    dest = remote_path
  elseif push_or_pull == "pull" then
    source = remote_path
    dest = local_path
  else
    error("push_or_pull must be 'push' or 'pull'", 0)
  end
  action = defaultIfNil(action, "copy")
  run({
    "rclone",
    action,
    { value = source, type = "quoted" },
    { value = dest, type = "quoted" },
  }, final_run_param)
end
