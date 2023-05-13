--- @type ItemSpecifier
LibreofficeApplicationSpecifier = {
  type = "libreoffice",
  properties = {
    getables = {
      ["reload-menu-command"] = function(self)
        return {"File", "Reload"}
      end,
    },
    doThisables = {
      
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateLibreofficeApplication = bindArg(NewDynamicContentsComponentInterface, LibreofficeApplicationSpecifier)