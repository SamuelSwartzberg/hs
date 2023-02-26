

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
  run({
    "rclone",
    action,
    { value = source, type = "quoted" },
    { value = dest, type = "quoted" },
  }, true)
end

---@return nil
function syncVdirSyncer()
  run({
    "vdirsyncer",
    "sync",
  }, true)
end

---@param path string
function commitAllAndPush(path)
  CreateStringItem(path):doThis("git-commit-all-and-push")
end

---@param path string
function pullAll(path)
  CreateStringItem(path):doThis("git-pull-all")
end