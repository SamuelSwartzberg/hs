ManagedArraySpecifier = {
  type = "managed-array",
  properties = {
    doThisables = {
      ["remove-by-reference"] = function(self, item)
        local index = self:get("find-index", function(callback_item) return callback_item:get("id") == item:get("id") end)
        return self:get("remove-by-index", index)
      end,
      ["update-interface-if-necessary"] = function(self, item) 
      -- since we only check the interfaces of the array on generation, we need to check whether the interfaces of the array are incorrect whenever we add a new item
        if self:get("needs-interface-update") then
          self:doThis("update-interface")
        end  
      end,
      ["create-all"] = function(self, specifiers)
        for key, specifier in transf.table.pair_stateless_iter(specifiers) do
          if not specifier.speckey then
            specifier.speckey = key
          end
          self:doThis("create", specifier)
        end
      end,
      ["update-items"] = function(self)
        self:doThis("for-all", function(item) item:doThis("update") end)
      end,
      ["create"] = function(self, specifier)
        if self:get("has-custom-create-logic") then
          self:doThis("use-custom-create-logic", specifier)
        else
          dothis.array.unshift(self:get("c"), self:get("creator")(specifier))
        end
      end,
    },
  },
  action_table = {}
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateManagedArray = bindArg(NewDynamicContentsComponentInterface, ManagedArraySpecifier)