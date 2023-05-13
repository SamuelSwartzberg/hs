--- @type ItemSpecifier
LoggingDirSpecifier = {
  type = "logging-dir",
  properties = {
    getables = {
      ["log-for-date"] = function (self, dt)
        local y_ym_ymd = {
          dt:fmt("%Y"),
          dt:fmt("%Y-%m"),
          dt:fmt("%Y-%m-%d"),
        }
        local path = self:get("contents") .. "/" .. table.concat(y_ym_ymd, "/") .. ".csv"
        return path
      end
    },
    doThisables = {
      ["log-timestamp-table"] = function(self, timestamp_table)
        local ymd_array_table = timestampKeyTableToYMDTable(timestamp_table)
        self:doThis("table-to-fs", {
          payload = ymd_array_table,
          mode = "write",
          extension = "csv",
        })
      end,
      ["log-now"] = function(self, contents)
        self:doThis("log-timestamp-table", ovtable.init({{
          key = tostring(os.time()),
          value = {returnUnpackIfTable(contents)}
        }}))
      end,
      ["log-now-empty"] = function(self)
        self:doThis("log-now", {})
      end,
    }
  },
}


--- @type BoundNewDynamicContentsComponentInterface
CreateLoggingDir = bindArg(NewDynamicContentsComponentInterface, LoggingDirSpecifier)