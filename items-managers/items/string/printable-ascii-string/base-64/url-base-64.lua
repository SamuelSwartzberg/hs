--- @type ItemSpecifier
UrlBase64ItemSpecifier = {
  type = "url-base64",
  properties = {
    getables = {
      ["is-base-64"] = transf["nil"]["true"],
      ["is-citable-object-id"] = transf["nil"]["true"]
    }
  },
  ({
    { key = "base-64", value = CreateBase64Item },
    { key = "citable-object-id", value = CreateIndicatedCitableObjectIdItem },
  }),
  action_table = {}

}


--- @type BoundNewDynamicContentsComponentInterface
CreateUrlBase64Item = bindArg(NewDynamicContentsComponentInterface, UrlBase64ItemSpecifier)