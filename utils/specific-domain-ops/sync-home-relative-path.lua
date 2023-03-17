---syncs files to and from the remote server using rclone
---@param path string the path, relative to the home directory on local and to the root directory on remote
---@param push_or_pull "push"|"pull"
---@param action? "copy" | "move"
---@return nil
function syncHomeRelativePath(path, push_or_pull, action)
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
    error("push_or_pull must be 'push' or 'pull'")
  end
  action = defaultIfNil(action, "copy")
  run({
    "rclone",
    action,
    { value = source, type = "quoted" },
    { value = dest, type = "quoted" },
  }, true)
end
