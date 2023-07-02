--- @type ItemSpecifier
BrowserApplicationApplicationSpecifier = {
  type = "browser-application",
  properties = {
    doThisables = {
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
 
  action_table = concat({
  }, getChooseItemTable({}))

}

--- @type BoundNewDynamicContentsComponentInterface
CreateBrowserApplicationApplication = bindArg(NewDynamicContentsComponentInterface, BrowserApplicationApplicationSpecifier)
