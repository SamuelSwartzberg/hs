--- @type ItemSpecifier
DoiItemSpecifier = {
  type = "doi",
  properties = {
    getables = {
      ["is-citable-object-id"] = function() return true end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "citable-object-id", value = CreateIndicatedCitableObjectIdItem },
  }),

}

--- @type BoundNewDynamicContentsComponentInterface
CreateDoiItem = bindArg(NewDynamicContentsComponentInterface, DoiItemSpecifier)