--- @type ItemSpecifier
JxaWindowItemSpecifier = {
  type = "jxa-window-item",
  properties = {
    getables = {
      ["window-index-jxa"] = function(self)
        return getViaJXA(
          "Application('" .. self:get("application-name") .. "')" ..
            ".windows().findIndex(" ..
              "window => window.title() == '" .. self:get("filtered-title") .. "'" ..
            ")"
        )
      end,
      ["simple-property"] = function(self, prop)
        return getOrDoAppWindowField(self:get("application-name"), self:get("window-index-jxa"), prop)
      end,
    },
    doThisables = {
      

    }
  },

}

--- @type BoundNewDynamicContentsComponentInterface
CreateJxaWindowItem = bindArg(NewDynamicContentsComponentInterface, JxaWindowItemSpecifier)

