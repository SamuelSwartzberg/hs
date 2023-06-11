--- @type ItemSpecifier
UrlBase64ItemSpecifier = {
  type = "url-base64",
  properties = {
    getables = {
      ["is-base-64"] = returnTrue,
      ["is-citable-object-id"] = returnTrue,
      ["decode-url-base-64"] = function(self)
        return transf.string.base64_url(self:get("c"))
      end,
      ["decode-base-64"] = function(self) return self:get("decode-url-base-64") end
    }
  },
  potential_interfaces = ovtable.init({
    { key = "base-64", value = CreateBase64Item },
    { key = "citable-object-id", value = CreateCitableObjectIdItem },
  }),
  action_table = {}

}


--- @type BoundNewDynamicContentsComponentInterface
CreateUrlBase64Item = bindArg(NewDynamicContentsComponentInterface, UrlBase64ItemSpecifier)