--- @type ItemSpecifier
TabItemSpecifier = {
  type = "tab-item",
  properties = {
    getables = {
      ["is-implementation-tab"] = returnTrue,
      ["is-interface-tab"] = returnTrue,
      ["is-combination-tab"] = returnTrue,
      ["snapshot"] = function(self)
        return self:get("window"):snapshot()
      end,
      ["application-name"] = function(self)
        return self:get("running-application"):title()
      end,
      ["window-index"] = function(self)
        return self:get("running-application-item"):get("window-index", self:get("window"))
      end,
      ["to-string"] = function(self)
        return ("%s %s (%s:%d)"):format(self:get("title"), self:get("extra-tab-info"), self:get("application-name"), self:get("window-index"))
      end,

    },
    doThisables = {
      ["focus"] = function(self)
        self:doThis("make-main")
        self:get("window"):focus()
      end,
      ["do-on-application-w-tab-as-main"] = function(self, callback)
        local application = self:get("running-application-item")
        local prev_main = application:get("main-tab-item")
        self:doThis("make-main")
        callback(application)
        if prev_main then
          prev_main:doThis("make-main")
        end
      end,

    }
  },
  potential_interfaces = ovtable.init({ -- order is important here
    { key = "implementation-tab", value = CreateTabImplementationItem },
    { key = "interface-tab", value = CreateTabInterfaceItem },
    { key = "combination-tab", value = CreateTabCombinationItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateTabItem = bindArg(NewDynamicContentsComponentInterface, TabItemSpecifier)
