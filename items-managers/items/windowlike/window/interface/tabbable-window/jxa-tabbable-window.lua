--- @type ItemSpecifier
JxaTabbableWindowItemSpecifier = {
  type = "jxa-tabbable-window-item",
  properties = {
    getables = {
      ["amount-of-tabs"] = function(self)
        local parsed_res = getViaOSA("js", 
          "Application('" .. self:get("application-name") .. "')" ..
            ".windows().find(" ..
              "window => window.title() == '" .. self:get("filtered-title") .. "'" ..
            ").tabs().length"
        )
        if type(parsed_res) == "number" then
          return parsed_res
        else
          return 0
        end
      end,
      ["list-of-tabs"] = function(self)
        local res = {}
        local window_index = self:get("window-index-jxa")
        for i = 0, self:get("amount-of-tabs") - 1 do
          table.insert(res, CreateWindowlikeItem({
            window_index = window_index,
            tab_index = i,
            app = self:get("running-application"),
            type = "jxa"
          }))
        end
        return res
      end,
      ["active-tab-index"] = function(self)
        return getViaOSA("js", ("Application('%s').windows()[%d].%s()"):format(self:get("application-name"), self:get("window-index-jxa"), "activeTabIndex")) - 1
      end,
      ["active-tab"] = function(self)
        local window_index = self:get("window-index-jxa")
        local tab_index = self:get("active-tab-index")
        return CreateWindowlikeItem({
          window_index = window_index,
          tab_index = tab_index ,
          app = self:get("application-name"),
          type = "jxa"
        })
      end,
      ["filtered-title"] = function(self)
        return self:get("raw-title"):gsub(" %- " .. self:get("application-name"), "")
      end,
    },
    doThisables = {
      

    }
  },

}

--- @type BoundNewDynamicContentsComponentInterface
CreateJxaTabbableWindowItem = bindArg(NewDynamicContentsComponentInterface, JxaTabbableWindowItemSpecifier)

