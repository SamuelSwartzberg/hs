--- @type ItemSpecifier
CrockfordBase32ItemSpecifier = {
  type = "crockford-base32",
  properties = {
    getables = {
      ["is-base-32"] = transf["nil"]["true"],
    }
  },
  ({
    { key = "base-32", value = CreateBase32Item },
  }),
  action_table = {}

}


--- @type BoundNewDynamicContentsComponentInterface
CreateCrockfordBase32Item = bindArg(NewDynamicContentsComponentInterface, CrockfordBase32ItemSpecifier)