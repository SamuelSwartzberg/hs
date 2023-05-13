--- @type ItemSpecifier
GitItemSpecifier = {
  type = "git",
  properties = {
    getables = {
     
    },
    doThisables = {
      ["backup-application"] = function(self)
        CreateStringItem(env.TMP_GIT_LOG_PARENT):get("child-string-item-array"):doThis("for-all", function(child)
          if child:get("is-csv-table-file") then
            CreateStringItem(
              CreateStringItem(env.MDIARY_COMMITS):get(
                "find-or-create-logging-date-managed-child-dir",
                {
                  find_identifier_suffix = child:get("leaf-without-extension")
                }
              )
            ):doThis("log-timestamp-table", child:get("read-to-rows"))
          end
        end)
      end,
    }
  },
  
 

}

--- @type BoundNewDynamicContentsComponentInterface
CreateGitItem = bindArg(NewDynamicContentsComponentInterface, GitItemSpecifier)