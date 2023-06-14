--- @type ItemSpecifier
UrlBase64ItemSpecifier = {
  type = "url-base64",
  properties = {
    getables = {
      ["is-base-64"] = returnTrue,
      ["is-citable-object-id"] = returnTrue
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