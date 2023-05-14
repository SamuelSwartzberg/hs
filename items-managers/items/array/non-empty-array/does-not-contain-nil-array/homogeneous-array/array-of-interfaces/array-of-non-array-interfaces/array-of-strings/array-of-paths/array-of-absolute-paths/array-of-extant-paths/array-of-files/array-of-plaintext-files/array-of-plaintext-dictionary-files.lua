
ArrayOfPlaintextDictionaryFilesSpecifier = {
  type = "array-of-plaintext-dictionary-files",
  properties = {
    getables = {
      ["to-single-env-map"] = function(self)
        return self:get("map-to-new-array", function(item)
          return item:get("to-env-map")
        end):get("flatten-to-single-table")
      end,
    },
    doThisables = {
      
    },
  },
  action_table = {},
  
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfPlaintextDictionaryFiles = bindArg(NewDynamicContentsComponentInterface, ArrayOfPlaintextDictionaryFilesSpecifier)