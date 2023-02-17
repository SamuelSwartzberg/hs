--- @type ItemSpecifier
LibreofficeCommandSpecifier = {
  type = "libreoffice-command",
  properties = {
    getables = {
      ["to-txt-command"] = function (self, path)
        return {
          "cd",
          {value = getParentPath(path), type= "quoted"},
          "&&",
          "soffice",
          "--headless",
          "--convert-to",
          "txt:Text",
          {value = getLeafWithoutPath(path), type="quoted"},
        }
      end
    },
    doThisables = {
      
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateLibreofficeCommand = bindArg(NewDynamicContentsComponentInterface, LibreofficeCommandSpecifier)
