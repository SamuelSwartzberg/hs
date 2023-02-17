--- @type ItemSpecifier
FirefoxPlacesSqliteFileItemSpecifier = {
  type = "firefox-places-sqlite-file",
  properties = {
    getables = {
     },
    doThisables = {
      ["write-history-to-csv"] = function(self, do_after)
        self:doThis("write-to-csv", {
          query = "SELECT visit_date/1000000 AS timestamp,title,url " .. 
            "FROM moz_places " ..
            "INNER JOIN moz_historyvisits ON moz_places.id = moz_historyvisits.place_id " ..
            "ORDER BY timestamp DESC;",
          output_path = env.TMP_FIREFOX_HISTORY_CSV,
          do_after = do_after
        })
      end,
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateFirefoxPlacesSqliteFileItem = bindArg(NewDynamicContentsComponentInterface, FirefoxPlacesSqliteFileItemSpecifier)