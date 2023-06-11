--- @type ItemSpecifier
TitleUrlApplicationItemSpecifier = {
  type = "title-url-application",
  properties = {
    getables = {
      ["is-firefox"] = function(self)
        return self:get("contents") == "Firefox"
      end,
      ["is-newpipe"] = function (self)
        return self:get("contents") == "Newpipe"
      end
    },
    doThisables = {
      ["backup-application"] = function(self)
        self:doThis("pre-backup", function()
          dothis.sqlite_file.write_to_csv(self:get("backup-sqlite"), tblmap.application.history_sql_query[self:get("contents")], self:get("backup-csv-file-path"), function()
            local hist_csv = self:get("str-item", "backup-csv-file-path")
            local new = hist_csv:get("rows-after-using-last-access", true)
            if new then 
              CreateStringItem(self:get("backup-path")):doThis(
                "log-timestamp-table", 
                new
              )
            end
          end)
        end)
      end,
        
      
      
    }
  },
  potential_interfaces = ovtable.init({
    { key = "firefox", value = CreateFirefoxItem },
    { key = "newpipe", value = CreateNewpipeItem },
  }),
 

}

--- @type BoundNewDynamicContentsComponentInterface
CreateTitleUrlApplicationItem = bindArg(NewDynamicContentsComponentInterface, TitleUrlApplicationItemSpecifier)