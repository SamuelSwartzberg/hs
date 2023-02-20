--- mainly to hold on to tasks so they don't get garbage collected, and potentially to do things like restart/cancel/whatever

--- @type ItemSpecifier
TaskItemSpecifier = {
  type = "task-item",
  properties = {
    getables = {
      ["argsid"] = function(self)
        return json.encode(self:get("args"))
      end,
      ["args"] = function(self)
        return self:get("contents").args
      end,
      ["hstask"] = function(self)
        return self:get("contents").hstask
      end,
    },
    doThisables = {
      ["start"] = function (self)
        self:get("hstask"):start()
      end,
      ["pause"] = function(self)
        self:get("hstask"):pause()
      end,
      ["resume"] = function(self)
        self:get("hstask"):resume()
      end,
      ["stop"] = function(self)
        self:get("hstask"):terminate()
      end,
      ["recreate"] = function(self)
        self:doThis("stop")
        self:get("contents").hstask = runHsTask(self:get("args"))
      end,
    }
  }
}

--- @type BoundRootInitializeInterface
function CreateTaskItem(args)
  local hstask = runHsTask(args)
  local task = {
    hstask = hstask,
    args = args,
  }
  return RootInitializeInterface(TaskItemSpecifier, task)
end

