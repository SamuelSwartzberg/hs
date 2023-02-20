--- @param path string
--- @return string, string
function getHomeRemotePathPair(path)
  local relative_path = ensureAdfix(path, env.HOME, false, false, "pre")
  relative_path = ensureAdfix(relative_path, "/", false, false, "pre")
  local local_path = env.HOME .. "/" .. relative_path
  local remote_path = "hsftp:" .. path
  return local_path, remote_path
end

---@param path string
---@return string
function getRemotePath(path)
  local _, remote_path = getHomeRemotePathPair(path)
  return remote_path
end


---syncs files to and from the remote server using rclone
---@param path string
---@param push_or_pull "push"|"pull"
---@param action? "copy" | "move"
---@return nil
function syncHomeRelativePath(path, push_or_pull, action)
  local local_path, remote_path = getHomeRemotePathPair(path)
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
  runHsTask({
    "rclone",
    action,
    { value = source, type = "quoted" },
    { value = dest, type = "quoted" },
  })
end

---@return nil
function syncVdirSyncer()
  runHsTask({
    "vdirsyncer",
    "sync",
  })
end

---@param path string
function commitAllAndPush(path)
  CreateStringItem(path):doThis("git-commit-all-and-push")
end

---@param path string
function pullAll(path)
  CreateStringItem(path):doThis("git-pull-all")
end