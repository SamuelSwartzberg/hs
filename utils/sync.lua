---syncs files to and from the remote server using rclone
---@param path string
---@param push_or_pull "push"|"pull"
---@param move? boolean | "move"
---@return nil
function syncHomeRelativePath(path, push_or_pull, move)
  local local_path 
  if not stringy.startswith(path, "/") then
    local_path = env.HOME .. "/" .. path
  elseif stringy.startswith(path, env.HOME) then
    local_path = path
  else
    error("path must be in home")
  end
  local remote_path = "mailbox_webdav:/" .. path
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
  local action = "copy"
  if move then
    action = "move"
  end
  if pathExists(local_path) then
    runHsTask({
      "rclone",
      action,
      { value = source, type = "quoted" },
      { value = dest, type = "quoted" },
    })
  else
    error("path does not exist: " .. local_path)
  end
end

---@return nil
function syncVdirSyncer()
  runHsTask({
    "vdirsyncer",
    "sync",
  })
end