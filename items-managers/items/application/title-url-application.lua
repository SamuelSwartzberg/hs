--- @type ItemSpecifier
TitleUrlApplicationItemSpecifier = {
  type = "title-url-application",
  properties = {
    doThisables = {
      ["backup-application"] = function(self)
        self:doThis("pre-backup", function()
          self:get("backup-sqlite"), , self:get("backup-csv-file-path"), function()
            local hist_csv = self:get("str-item", "backup-csv-file-path")
            local new = transf.timestamp_first_column_plaintext_table_file.new_timestamp_key_array_value_dict(hist_csv:get("c"))
            if new then 
              st(self:get("backup-path")):doThis(
                "log-timestamp-table", 
                new
              )
            end
          end)
        end)
      end,
        
      
      
    }
  },
 

}

--- @type BoundNewDynamicContentsComponentInterface
CreateTitleUrlApplicationItem = bindArg(NewDynamicContentsComponentInterface, TitleUrlApplicationItemSpecifier)