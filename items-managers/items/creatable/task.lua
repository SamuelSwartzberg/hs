--- mainly to hold on to tasks so they don't get garbage collected, and potentially to do things like restart/cancel/whatever

--- @type ItemSpecifier
TaskItemSpecifier = {
  type = "task",
  properties = {
    getables = {
      ["created"] = function(self)
        return run(self:get("specifier").args)
      end,
    },
    doThisables = {
      ["start"] = function (self)
        self:get("hscreatable"):start()
      end,
      ["pause"] = function(self)
        self:get("hscreatable"):pause()
      end,
      ["resume"] = function(self)
        self:get("hscreatable"):resume()
      end,
      ["stop"] = function(self)
        self:get("hscreatable"):terminate()
      end,
      
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateTaskItem = bindArg(NewDynamicContentsComponentInterface, TaskItemSpecifier)