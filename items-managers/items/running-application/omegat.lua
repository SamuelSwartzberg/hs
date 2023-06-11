--- @type ItemSpecifier
OmegatApplicationSpecifier = {
  type = "omegat",
  properties = {
    getables = {
      ["open-recent-menu-command"] = function(self)
        return {"Project", "Open Recent Project"}
      end,
    },
    doThisables = {
      ["create-all-translated-documents"] = function(self)
        self:get("c"):selectMenuItem({"Project", "Create Translated Documents"})
      end,
      ["create-current-translated-document"] = function(self)
        self:get("c"):selectMenuItem({"Project", "Create Current Translated Document"})
      end,
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateOmegatApplication = bindArg(NewDynamicContentsComponentInterface, OmegatApplicationSpecifier)