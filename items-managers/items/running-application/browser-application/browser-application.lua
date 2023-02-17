--- @type ItemSpecifier
BrowserApplicationApplicationSpecifier = {
  type = "browser-application",
  properties = {
    getables = {
      ["current-url"] = function(self)
        return self:get("focused-window-item"):get("url")
      end,
      ["url-item"] = function(self)
        return CreateStringItem(self:get("current-url"))
      end,
      ["relevant-subdivision"] = function(self)
        local url_item = self:get("url-item")
        return url_item:get("url-domain-and-tld") or url_item:get("url-host")
      end,
    },
    doThisables = {
      ["open-url"] = function (self, url)
        runHsTask({
          "open",
          "-a", self:get("name"),
          { value = url, type = "quoted" }
        })
      end,
      ["load-session"] = function(self, session)
        session
          :get("descendants-to-line-array")
          :get("filter-empty-strings-to-new-array")
          :doThis("for-all", function(url)
            self:doThis("open-url", url)
          end)
      end,
    }
  },
 
  action_table = listConcat({
  }, getChooseItemTable({}))

}

--- @type BoundNewDynamicContentsComponentInterface
CreateBrowserApplicationApplication = bindArg(NewDynamicContentsComponentInterface, BrowserApplicationApplicationSpecifier)
