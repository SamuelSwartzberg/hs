

--- @type ItemSpecifier
M3uFileItemSpecifier = {
  type = "m3u-file",
  properties = {
    getables = {
      
    },
    doThisables = {
      ["lines-as-stream-queue"] = function(self)
        self
          :get("new-array-from-result-of-get", {key = "lines-of-file-contents"}):doThis("for-all", function(url)
            if url == "" then return end
            System:get("manager", "stream")
              :doThis(
                "create", 
                { initial_data = { urls = ar({CreateStringItem(url)})}}
              )
        end)
        self:doThis("empty-file")
      end,
    }
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreateM3uFileItem = bindArg(NewDynamicContentsComponentInterface, M3uFileItemSpecifier)