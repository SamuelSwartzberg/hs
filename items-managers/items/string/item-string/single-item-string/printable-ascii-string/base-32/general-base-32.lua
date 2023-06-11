--- @type ItemSpecifier
GeneralBase32ItemSpecifier = {
  type = "general-base32",
  properties = {
    getables = {
      ["is-base-32"] = returnTrue,
      ["decode-general-base-32"] = function(self)
        return transf.string.base32_gen(self:get("c"))
      end,
      ["decode-base-32"] = function(self) return self:get("decode-general-base-32") end
    }
  },
  potential_interfaces = ovtable.init({
    { key = "base-32", value =  CreateBase32Item}
  }),
  action_table = {}

}

--- @type BoundNewDynamicContentsComponentInterface
CreateGeneralBase32Item = bindArg(NewDynamicContentsComponentInterface, GeneralBase32ItemSpecifier)