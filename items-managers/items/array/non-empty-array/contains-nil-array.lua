
ContainsNilArraySpecifier = {
  type = "contains-nil-array",
  properties = {
    getables = {
      ["to-does-not-contain-nil-array"] = function(self)
        return ar(transf.hole_y_arraylike.array(self:get("c")))
      end,
    },
    doThisables = {
    },
  },
  action_table = {}
  
  }

--- @type BoundNewDynamicContentsComponentInterface
CreateContainsNilArray = bindArg(NewDynamicContentsComponentInterface, ContainsNilArraySpecifier)