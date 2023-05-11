ManagedClipboardArraySpecifier = {
  type = "managed-clipboard-array",
  properties = {
    getables = {
      ["format-noninterface-item-for-chooser"] = function(self, str)
        return slice(str, {
          stop = 250,
          sliced_indicator = "..."
        })
      end,
      ["has-custom-create-logic"] = returnTrue
    },
    doThisables = {
      ["use-custom-create-logic"] = function(self, args)
        local item = CreateStringItem(args)
        local contents = item:get("contents")
        local element_with_same_contents = self:get(
          "find",
          function (find_item) return find_item:get("contents") == contents end
        )
        if element_with_same_contents then
          self:doThis("move-to-front", element_with_same_contents)
        else
          self:doThis("add-to-front", item)
        end
      end,
      ["choose-item-and-paste"] = function(self)
        self:doThis("choose-item", function(item) item:doThis("paste-contents") end)
      end,
    },
    
  },
  
  action_table = {}
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateManagedClipboardArray = bindArg(NewDynamicContentsComponentInterface, ManagedClipboardArraySpecifier)

function CreateManagedClipboardArrayDirectly()
  local managed_clipboard_array = CreateArray({}, "clipboard")
  return managed_clipboard_array
end