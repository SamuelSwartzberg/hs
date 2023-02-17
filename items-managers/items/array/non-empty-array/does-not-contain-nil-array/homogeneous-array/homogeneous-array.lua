HomogeneousArraySpecifier = {
  type = "homogeneous-array",
  properties = {
    getables = {
      ["is-array-of-interfaces"] = function(self)
        return self:get("first").is_interface == true
      end,
      ["is-array-of-noninterfaces"] = function(self)
        return not self:get("first").is_interface
      end,
      ["to-string"] = function(self)
        return "array: " .. table.concat(
          self:get("map-elems-to-string"),
          ", "
        )
      end,
      ["to-string-multiline"] = function(self)
        return table.concat(
          self:get("map-elems-to-string"),
          "\n"
        )
      end

    },
    doThisables = {}
  },
  potential_interfaces = ovtable.init({
    { key = "array-of-interfaces", value = CreateArrayOfInterfaces },
    { key = "array-of-noninterfaces", value = CreateArrayOfNoninterfaces },
  }),
  action_table = listConcat({
      
  }, getChooseItemTable({
    {
      description = "tstr",
      emoji_icon = "💻🔡",
      key = "to-string",
    },
    {
      description = "tstrml",
      emoji_icon = "💻🔡📜",
      key = "to-string-multiline",
    },
  })),
}

--- @type BoundNewDynamicContentsComponentInterface
CreateHomogeneousArray = bindArg(NewDynamicContentsComponentInterface, HomogeneousArraySpecifier)



