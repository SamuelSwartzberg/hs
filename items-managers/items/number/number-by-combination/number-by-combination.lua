NumberByCombinationSpecifier = {
  type = "number-by-combination",
  properties = {
    getables = {
      ["is-pos-int"] = function(self)
        return is.any.pos_int(self:get("c"))
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