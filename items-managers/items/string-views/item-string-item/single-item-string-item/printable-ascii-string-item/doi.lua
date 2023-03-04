--- @type ItemSpecifier
DoiItemSpecifier = {
  type = "doi-item",
  properties = {
    getables = {
      ["is-citable-object-id"] = function() return true end,
      ["bibtex-from-internet"] = function(self)
        return run({
          "curl",
          "-LH",
          "Accept: application/x-bibtex",
          {
            value = toResolvedDoi(self:get("contents")),
            type = "quoted"
          }
        })
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "citable-object-id", value = CreateCitableObjectIdItem },
  }),

}

--- @type BoundNewDynamicContentsComponentInterface
CreateDoiItem = bindArg(NewDynamicContentsComponentInterface, DoiItemSpecifier)