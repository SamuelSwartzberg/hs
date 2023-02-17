--- @type ItemSpecifier
WindowlikeItemSpecifier = {
  type = "windowlike-item",
  properties = {
    getables = {
      ["running-application-item"] = function(self)
        return CreateRunningApplicationItem(self:get("running-application"))
      end,
      ["application-icon"] = function(self)
        return memoized.imageFromAppBundle(self:get("running-application"):bundleID())
      end,
      ["chooser-image"] = function(self)
        return self:get("application-icon")
      end,
      ["title"] = function(self)
        return self:get("filtered-title") or self:get("raw-title")
      end,
      ["is-tab"] = function (self)
        return not not self:get("contents").type
      end,
      ["is-window"] = function(self)
        return not not self:get("contents").isFullScreen -- arbitrary property that a window has but a tab doesn't
      end,


    },
    doThisables = {
     

    }
  },
  potential_interfaces = ovtable.init({
    { key = "tab", value = CreateTabItem },
    { key = "window", value = CreateWindowItem },
  })
}

--- @type BoundRootInitializeInterface
CreateWindowlikeItem = bindArg(RootInitializeInterface, WindowlikeItemSpecifier)