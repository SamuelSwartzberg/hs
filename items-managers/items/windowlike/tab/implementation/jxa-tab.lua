--- @type ItemSpecifier
JxaTabItemSpecifier = {
  type = "jxa-tab-item",
  properties = {
    getables = {
      ["simple-property"] = function(self, prop)
        local contents = self:get("contents")
        return getViaOSA("js", ("Application('%s').windows()[%d].tabs()[%d].%s()"):format(self:get("application-name"), contents.window_index, contents.tab_index, prop))
      end,
      ["raw-title"] = function(self)
        return self:get("simple-property", "title")
      end,
      ["url"] = function (self)
        return self:get("simple-property", "url")
      end,
      ["running-application"] = function(self)
        return self:get("contents").app
      end,
      ["window-title"] = function(self)
        return getViaOSA("js", ("Application('%s').windows()[%d].%s()"):format(self:get("application-name"), self:get("contents").window_index, "title"))
      end,
      ["window"] = function(self)
        return self:get("running-application-item"):get("get-window", self:get("window-title") .. " - " .. self:get("application-name"))
      end,
    },
    doThisables = {
       ["make-main"] = function(self)
        local contents = self:get("contents")
        getViaOSA("JS", ("Application('%s').windows()[%d].activeTabIndex = %d"):format(self:get("application-name"), contents.window_index, contents.tab_index + 1))
      end,
      ["close"] = function(self)
        local contents = self:get("contents")
        getViaOSA("js", ("Application('%s').windows()[%d].tabs()[%d].%s()"):format(self:get("application-name"), contents.window_index, contents.tab_index, "close"))
      end,

    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateJxaTabItem = bindArg(NewDynamicContentsComponentInterface, JxaTabItemSpecifier)

