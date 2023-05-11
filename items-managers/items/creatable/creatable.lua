--- @type ItemSpecifier
CreatableItemSpecifier = {
  type = "creatable-item",
  properties = {
    getables = {
      ["specifier"] = function(self)
        return self:get("contents").specifier
      end,
      ["hscreatable"] = function (self)
        return self:get("contents").hscreatable
      end,
      ["specid"] = function(self)
        local spec = self:get("specifier")
        local filteredSpec = {}
        for k,v in pairs(spec) do
          if type(v) ~= "userdata" and type(v) ~= "function" then
            filteredSpec[k] = v
          end
        end
        return json.encode(filteredSpec)
      end,
      ["type"] = function(self)
        return self:get("specifier").type
      end,
      
      ["is-task"] = function(self)
        return self:get("type") == "task"
      end,
      ["is-fireable"] = function(self)
        return self:get("specifier").fn ~= nil
      end,
      
    },
    doThisables = {
      ["recreate"] = function (self)
        self:doThis("stop")
        self:doThis("create-and-run")
      end,
      ["create-and-start"] = function(self)
        self:doThis("create")
        self:doThis("start")
      end,
      ["create"] = function(self)
        self:get("contents").hscreatable = self:get("created")
      end,
    }
  },
  potential_interfaces = ovtable.init({
    
    { key = "task", value = CreateTaskItem },
    { key = "fireable", value = CreateFireableItem },
  }),
}

--- @type BoundRootInitializeInterface
function CreateCreatableItem(specifier)
  specifier.type = specifier.type or "hotkey"
  local creatable = RootInitializeInterface(CreatableItemSpecifier, {
    specifier = specifier
  })
  creatable:doThis("add-defaults-to-specifier")
  creatable:doThis("create-and-start")
  return creatable
end

