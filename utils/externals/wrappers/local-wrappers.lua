--- these exist only for use somewhere where a function is needed

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

--- @param namespace string
--- @param key string
--- @param value string
function writeDefault(namespace, key, value)
  return run({"defaults", "write", namespace, key, value})
end

