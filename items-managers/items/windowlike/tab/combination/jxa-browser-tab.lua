--- @type ItemSpecifier
JxaBrowserTabItemSpecifier = {
  type = "jxa-browser-tab-item",
  properties = {
    getables = {
      ["url"] = function (self)
        return self:get("simple-property", "url")
      end,
    },
    doThisables = {

    }
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreateJxaBrowserTabItem = bindArg(NewDynamicContentsComponentInterface, JxaBrowserTabItemSpecifier)

