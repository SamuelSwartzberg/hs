ManagedArraySpecifier = {
  type = "managed-array",
  properties = {
    getables = {
      ["needs-interface-update"] = function(self)
        return self:get("length") == 1 -- this is a hack: I presume that if the array has only one item, we've just added the first item, and thus we definitely need to update the interface. Theoretically we would also need to see if the interface needs to be updated for any added item by comparing their lists of types, but that is quite difficult, and currently I only ever use managed arrays as homogeneous arrays, for which the types will be the same no matter how many items I add.
        
      end,
      ["find-contents-or-create"] = function (self, contents)
        local res = self:get("find-contents", contents)
        if res then
          return res
        else
          return self:get("create", contents)
        end
      end
    },
    doThisables = {
      ["add-to-end"] = function(self, item)
        push(self:get("contents"), item)
        self:doThis("update-interface-if-necessary", item)
      end,
      ["add-to-front"] = function(self, item)
        table.insert(self:get("contents"), 1, item)
        self:doThis("update-interface-if-necessary", item)
      end,
      ["remove-by-id"] = function (self, id)
        local index = self:get("find-index", function(item) return item:get("id") == id end)
        return self:get("remove-by-index", index)
      end,
      ["remove-by-reference"] = function(self, item)
        local index = self:get("find-index", function(callback_item) return callback_item:get("id") == item:get("id") end)
        return self:get("remove-by-index", index)
      end,
      ["filter-in-place-valid"] = function(self)
        for i, item in ipairs(self:get("contents")) do
          if not item:get("is-valid") then
            self:get("remove-by-index", i)
          end
        end
      end,
      ["maintain-state"] = function(self)
        self:doThis("update-items")
        self:doThis("filter-in-place-valid")
      end,
      ["update-interface"] = function(self)
        self.root_super:setContents(self:get("contents")) -- this seems like it would be useless, but in fact setting the contents forces the interface to check which potential interfaces apply now
      end,
      ["update-interface-if-necessary"] = function(self, item) 
      -- since we only check the interfaces of the array on generation, we need to check whether the interfaces of the array are incorrect whenever we add a new item
        if self:get("needs-interface-update") then
          self:doThis("update-interface")
        end  
      end,
      ["create-all"] = function(self, specifiers)
        for i, specifier in ipairs(specifiers) do
          self:doThis("create", specifier)
        end
      end,
      ["update-items"] = function(self)
        self:doThis("for-all", function(item) item:doThis("update") end)
      end,
      ["move-to-index"] = function(self, args)
        local index_of_item = self:get("find-index", function(item) return item == args.item end)
        self:get("remove-by-index", index_of_item)
        table.insert(self:get("contents"), args.index, args.item)
      end,
      ["move-to-front"] = function(self, item)
        self:doThis("move-to-index", {item = item, index = 1})
      end,
      ["move-to-back"] = function(self, item)
        self:doThis("move-to-index", item, self:get("length"))
      end,
      ["clear"] = function(self)
        self:get("contents")
      end,
      ["sort"] = function(self, callback)
        table.sort(self:get("contents"), callback)
      end,
      ["shuffle"] = function(self)
        self:doThis("sort", function(a, b) return math.random() > 0.5 end)
      end,
    },
  },
  potential_interfaces = ovtable.init({
    { key = "managed-clipboard-array", value = CreateManagedClipboardArray },
    { key = "managed-hotkey-array", value = CreateManagedHotkeyArray },
    { key = "managed-stream-array", value = CreateManagedStreamArray },
    { key = "managed-timer-array", value = CreateManagedTimerArray },
    { key = "managed-watcher-array", value = CreateManagedWatcherArray },
    { key = "managed-task-array", value = CreateManagedTaskArray },
    { key = "managed-api-array", value = CreateManagedApiArray },
    { key = "managed-input-method-array", value = CreateManagedInputMethodArray },
  }),
  action_table = {}
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateManagedArray = bindArg(NewDynamicContentsComponentInterface, ManagedArraySpecifier)