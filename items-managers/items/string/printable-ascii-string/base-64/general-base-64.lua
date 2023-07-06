--- @type ItemSpecifier
GeneralBase64ItemSpecifier = {
  type = "general-base64",
  properties = {
    getables = {
      ["is-base-64"] = transf["nil"]["true"],
    }
  },
  potential_interfaces = ovtable.init({
    { key = "base-64", value = CreateBase64Item }
  }),
  action_table = {}

}

--- @type BoundNewDynamicContentsComponentInterface
CreateGeneralBase64Item = bindArg(NewDynamicContentsComponentInterface, GeneralBase64ItemSpecifier)