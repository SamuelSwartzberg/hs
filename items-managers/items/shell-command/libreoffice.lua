--- @type ItemSpecifier
LibreofficeCommandSpecifier = {
  type = "libreoffice-command",
  properties = {
    getables = {
      ["to-txt-command"] = function (self, path)
        return {
          "cd",
          {value = pathSlice(path, ":-2", {rejoin_at_end=true}), type= "quoted"},
          "&&",
          "soffice",
          "--headless",
          "--convert-to",
          "txt:Text",
          {value = pathSlice(path, "-1:-1")[1], type="quoted"},
        }
      end
    },
    doThisables = {
      
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateLibreofficeCommand = bindArg(NewDynamicContentsComponentInterface, LibreofficeCommandSpecifier)
