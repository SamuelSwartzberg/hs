
ContainsNilArraySpecifier = {
  type = "contains-nil-array",
  properties = {
    getables = {
      ["to-does-not-contain-nil-array"] = function(self)
        return ar(fixListWithNil(self:get("c")))
      end,
    },
    doThisables = {
    },
  },
  action_table = {}
  
  }

--- @type BoundNewDynamicContentsComponentInterface
CreateContainsNilArray = bindArg(NewDynamicContentsComponentInterface, ContainsNilArraySpecifier)