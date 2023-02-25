NumberByNumberSetSpecifier = {
  type = "number-by-number-set",
  properties = {
    getables = {
      ["is-int"] = function(self)
        return isNumber(self:get("contents"), "int")
      end,
      ["is-float"] = function(self)
        return isNumber(self:get("contents"), "float")
      end,
      
    },
    doThisables = {
     
    }
  },
  potential_interfaces = ovtable.init({
    { key = "int", value = CreateInt },
    { key = "float", value = CreateFloat },
  }),
  action_table = {

  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateNumberByNumberSet = bindArg(NewDynamicContentsComponentInterface, NumberByNumberSetSpecifier)