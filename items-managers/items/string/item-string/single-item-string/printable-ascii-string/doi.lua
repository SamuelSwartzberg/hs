--- @type ItemSpecifier
DoiItemSpecifier = {
  type = "doi",
  properties = {
    getables = {
      ["is-citable-object-id"] = function() return true end,
      ["bibtex-from-internet"] = function(self)
        return transf.doi.bibtex(self:get("c"))
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "citable-object-id", value = CreateCitableObjectIdItem },
  }),

}

--- @type BoundNewDynamicContentsComponentInterface
CreateDoiItem = bindArg(NewDynamicContentsComponentInterface, DoiItemSpecifier)