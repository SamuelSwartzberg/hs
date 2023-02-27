--- @type ItemSpecifier
DoiItemSpecifier = {
  type = "doi-item",
  properties = {
    getables = {
      ["is-citable-object-id"] = function() return true end,
      ["bibtex-from-internet"] = function(self)
        return getBibtexFromDoi(self:get("contents"))
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "citable-object-id", value = CreateCitableObjectIdItem },
  }),

}

--- @type BoundNewDynamicContentsComponentInterface
CreateDoiItem = bindArg(NewDynamicContentsComponentInterface, DoiItemSpecifier)