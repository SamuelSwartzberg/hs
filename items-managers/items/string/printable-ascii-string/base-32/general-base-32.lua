--- @type ItemSpecifier
GeneralBase32ItemSpecifier = {
  type = "general-base32",
  properties = {
    getables = {
      ["is-base-32"] = transf["nil"]["true"],
    }
  },
  ({
    { key = "base-32", value =  CreateBase32Item}
  }),
  action_table = {}

}

--- @type BoundNewDynamicContentsComponentInterface
CreateGeneralBase32Item = bindArg(NewDynamicContentsComponentInterface, GeneralBase32ItemSpecifier)