NumberByNumberSetSpecifier = {
  type = "number-by-number-set",
  properties = {
    getables = {
      ["is-int"] = function(self)
        return is.number.int(self:get("contents"))
      end,
      ["is-float"] = function(self)
        return is.number.float(self:get("contents"))
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