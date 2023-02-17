--- @type ItemSpecifier
NewpipeSqliteFileItemSpecifier = {
  type = "newpipe-sqlite-file",
  properties = {
    getables = {
     },
    doThisables = {
      ["write-history-to-csv"] = function(self, do_after)
        self:doThis("write-to-csv", {
          query = "SELECT access_date/1000 AS timestamp,title,url " .. 
            "FROM stream_history " ..
            "INNER JOIN streams ON stream_history.stream_id = streams.uid " ..
            "ORDER BY timestamp DESC;",
          output_path = env.TMP_NEWPIPE_HISTORY_CSV,
          do_after = do_after
        })
      end,
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateNewpipeSqliteFileItem = bindArg(NewDynamicContentsComponentInterface, NewpipeSqliteFileItemSpecifier)