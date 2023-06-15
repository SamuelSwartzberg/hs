--- @type ItemSpecifier
CrockfordBase32ItemSpecifier = {
  type = "crockford-base32",
  properties = {
    getables = {
      ["is-base-32"] = returnTrue,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "base-32", value = CreateBase32Item },
  }),
  action_table = {}

}


--- @type BoundNewDynamicContentsComponentInterface
CreateCrockfordBase32Item = bindArg(NewDynamicContentsComponentInterface, CrockfordBase32ItemSpecifier)