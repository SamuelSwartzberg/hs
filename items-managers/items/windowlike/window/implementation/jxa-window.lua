--- @type ItemSpecifier
JxaWindowItemSpecifier = {
  type = "jxa-window-item",
  properties = {
    getables = {
      ["window-index-jxa"] = function(self)
        return getViaOSA("js", 
          "Application('" .. self:get("application-name") .. "')" ..
            ".windows().findIndex(" ..
              "window => window.title() == '" .. self:get("filtered-title") .. "'" ..
            ")"
        )
      end,
      ["simple-property"] = function(self, prop)
        return getViaOSA("js", ("Application('%s').windows()[%d].%s()"):format(self:get("application-name"), self:get("window-index-jxa"), prop))
      end,
    },
    doThisables = {
      

    }
  },

}

--- @type BoundNewDynamicContentsComponentInterface
CreateJxaWindowItem = bindArg(NewDynamicContentsComponentInterface, JxaWindowItemSpecifier)

