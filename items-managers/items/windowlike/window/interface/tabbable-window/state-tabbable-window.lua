-- contents is the kind of object in the json file provided by ff

--- @type ItemSpecifier
StateTabbableWindowItemSpecifier = {
  type = "state-tabbable-window-item",
  properties = {
    getables = {
      ["list-of-tabs"] = function(self)
        local res = {}
        print(self:get("types-of-all-valid-interfaces"))
        for i, tab in ipairs(self:get("window-in-state-json").tabs) do
          tab.window = self:get("contents")
          tab.type = "state"
          tab.app = self:get("running-application")
          tab.index = i
          table.insert(res, CreateWindowlikeItem(tab))
        end
        return res
      end,
      ["active-tab"] = function(self)
        local list_of_tabs = self:get("list-of-tabs")
        local window_title = self:get("raw-title")
        for i, tab in ipairs(list_of_tabs) do
          if tab:get("raw-title") == window_title then
            return tab
          end
        end
      end,
    },
    doThisables = {
      
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateStateTabbableWindowItem = bindArg(NewDynamicContentsComponentInterface, StateTabbableWindowItemSpecifier)

