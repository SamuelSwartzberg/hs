--- @type ItemSpecifier
GeneralBase64ItemSpecifier = {
  type = "general-base64",
  properties = {
    getables = {
      ["is-base-64"] = returnTrue,
      ["decode-general-base-64"] = function(self)
        return transf.string.base64_gen(self:get("contents"))
      end,
      ["decode-base-64"] = function(self) return self:get("decode-general-base-64") end
    }
  },
  potential_interfaces = ovtable.init({
    { key = "base-64", value = CreateBase64Item }
  }),
  action_table = {}

}

--- @type BoundNewDynamicContentsComponentInterface
CreateGeneralBase64Item = bindArg(NewDynamicContentsComponentInterface, GeneralBase64ItemSpecifier)