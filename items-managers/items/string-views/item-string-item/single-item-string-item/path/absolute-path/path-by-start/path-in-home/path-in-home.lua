--- @type ItemSpecifier
PathInHomeItemSpecifier = {
  type = "path-in-home-item",
  properties = {
    getables = {
      ["is-path-in-me"] = function (self)
        return stringy.startswith(self:get("completely-resolved-path"), env.ME)
      end,
      ["is-path-in-screenshots"] = function (self)
        return stringy.startswith(self:get("completely-resolved-path"), env.SCREENSHOTS)
      end,
    },
    doThisables = {
     
    }
  },
  potential_interfaces = ovtable.init({
    { key = "path-in-me", value = CreatePathInMeItem },
    { key = "path-in-screenshots", value = CreatePathInScreenshotsItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathInHomeItem = bindArg(NewDynamicContentsComponentInterface, PathInHomeItemSpecifier)