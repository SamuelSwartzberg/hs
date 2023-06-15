NumberByCombinationSpecifier = {
  type = "number-by-combination",
  properties = {
    getables = {
      ["is-pos-int"] = bc(is.any.pos_int)
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