--- @type ItemSpecifier
CrockfordBase32ItemSpecifier = {
  type = "crockford-base32",
  properties = {
    getables = {
      ["is-base-32"] = returnTrue,
      ["decode-crockford-base-32"] = function(self)
        return transf.string.base32_crock(self:get("contents"))
      end,
      ["decode-base-32"] = function(self) return self:get("decode-crockford-base-32") end
    }
  },
  potential_interfaces = ovtable.init({
    { key = "base-32", value = CreateBase32Item },
  }),
  action_table = {}

}


--- @type BoundNewDynamicContentsComponentInterface
CreateCrockfordBase32Item = bindArg(NewDynamicContentsComponentInterface, CrockfordBase32ItemSpecifier)