--- @type ItemSpecifier
PathInScreenshotsItemSpecifier = {
  type = "path-in-screenshots-item",
  properties = {
    getables = {
      ["base-path"] = function(self)
        return env.SCREENSHOTS
      end,
      ["to-string"] = function(self)
        self:get("relative-path")
      end,
    },
    doThisables = {
     
    }
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathInScreenshotsItem = bindArg(NewDynamicContentsComponentInterface, PathInScreenshotsItemSpecifier)