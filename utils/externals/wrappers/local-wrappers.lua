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
  st(path):doThis("git-commit-all-and-push")
end

---@param path string
function pullAll(path)
  st(path):doThis("git-pull-all")
end

--- @param ... string[]
function writeDefault(...)
  local args = {...}
  local command = concat({
    "defaults",
    "write",
  }, args)
  run(command, true)
end

