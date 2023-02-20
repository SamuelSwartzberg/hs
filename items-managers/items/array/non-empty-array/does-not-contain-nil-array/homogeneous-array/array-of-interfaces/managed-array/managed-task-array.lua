ManagedTaskArraySpecifier = {
  type = "managed-task-array",
  properties = {
    getables = {
      ["find-by-args"] = function(self, args)
        local argsid = json.encode(args)
        return self:doThis("find", function(task)
          return task:get("argsid") == argsid
        end)
      end
    },
    doThisables = {
      ["create"] = function(self, specifier)
        self:doThis("add-to-end", CreateTaskItem(specifier))
      end,
      ["register-all"] = function(self, specifiers)
        print("registering")
        for _, specifier in ipairs(specifiers) do
          self:doThis("create", specifier)
        end
      end
    },
  },
  
  action_table = {}
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateManagedTaskArray = bindArg(NewDynamicContentsComponentInterface, ManagedTaskArraySpecifier)

function CreateManagedTaskArrayDirectly()
  local managed_task_array = CreateArray({}, "task")
  return managed_task_array
end