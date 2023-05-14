
ArrayOfFilesSpecifier = {
  type = "array-of-files",
  properties = {
    getables = {
      ["is-array-of-plaintext-files"] = bind(isArrayOfInterfacesOfType, {a_use, "plaintext-file" }),
      ["map-to-array-of-contents"] = function(self)
        return self:get("map-to-new-array", function(item)
          return item:get("file-contents")
        end)
      end,
      ["filter-to-extension"] = function(self, extension)
        return self:get("filter-to-new-array", function(item)
          return item:get("path-leaf-extension") == extension
        end)
      end,
    },
    doThisables = {
    },
  },
  action_table = {},
  potential_interfaces = ovtable.init({
    { key = "array-of-plaintext-files", value = CreateArrayOfPlaintextFiles },
  }),
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfFiles = bindArg(NewDynamicContentsComponentInterface, ArrayOfFilesSpecifier)