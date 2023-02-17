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
  action_table = getSearchEngineActionTable(
    {
      name = "scihub",
      emoji_icon = "🦅" -- actually, scihub's logo is a raven, but tfw no raven emoji
    }
  )

}

--- @type BoundNewDynamicContentsComponentInterface
CreateDoiItem = bindArg(NewDynamicContentsComponentInterface, DoiItemSpecifier)