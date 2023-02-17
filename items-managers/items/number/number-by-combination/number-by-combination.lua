NumberByCombinationSpecifier = {
  type = "number-by-combination",
  properties = {
    getables = {
      ["is-pos-int"] = function(self)
        return isInt(self:get("contents")) and self:get("contents") > 0 -- can't use the self:get("is-int") etc. methods since we can't guarantee that the interface has been initialized yet
      end,
    },
    doThisables = {
     
    }
  },
  potential_interfaces = ovtable.init({
    { key = "pos-int", value = CreatePosInt },
  }),
  action_table = {

  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateNumberByCombination = bindArg(NewDynamicContentsComponentInterface, NumberByCombinationSpecifier)