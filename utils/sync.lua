--- @param path string
--- @param other_root string must provide its own trailing slash if needed, to allow for relative hosts disallowing a trailing slash
--- @return string, string
function getHomeOtherRootPathPair(path, other_root)
  local relative_path = ensureAdfix(path, env.HOME, false, false, "pre")
  relative_path = ensureAdfix(relative_path, "/", false, false, "pre")
  local local_path = env.HOME .. "/" .. relative_path
  local remote_path = other_root .. path
  return local_path, remote_path
end

---@param path string
---@param other_root string
---@return string
function getPathRelativeToOtherRoot(path, other_root)
  local _, relative_path = getHomeOtherRootPathPair(path, other_root)
  return relative_path
end

getOnRemote = bindNthArg(getPathRelativeToOtherRoot, 2, "hsftp:")
getOnFsHttpServer = bindNthArg(getPathRelativeToOtherRoot, 2, env.FS_HTTP_SERVER .. "/")


---syncs files to and from the remote server using rclone
---@param path string
---@param push_or_pull "push"|"pull"
---@param action? "copy" | "move"
---@return nil
function syncHomeRelativePath(path, push_or_pull, action)
  local local_path, remote_path = getHomeOtherRootPathPair(path, "hsftp:")
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