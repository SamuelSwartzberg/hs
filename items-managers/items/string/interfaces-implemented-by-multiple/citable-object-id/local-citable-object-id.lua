--- @type ItemSpecifier
LocalCitableObjectIdItemSpecifier = {
  type = "local-citable-object-id",
  properties = {
    getables = {
      ["bib-from-citation-file"] = function(self)
        return self:get("local-citation-file-if-any")
          :get("file-contents")
      end,
    },
    doThisables = {
    }
  },
  action_table = {},
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateLocalCitableObjectIdItem = bindArg(NewDynamicContentsComponentInterface, LocalCitableObjectIdItemSpecifier)