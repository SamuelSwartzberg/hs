--- @type ItemSpecifier
LoggingDirSpecifier = {
  type = "logging-dir",
  properties = {
    doThisables = {
      ["log-timestamp-table"] = function(self, timestamp_key_array_value_dict)
        local ymd_array_table = transf.timestamp_key_array_value_dict.ymd_nested_key_array_of_arrays_value_assoc_arr(timestamp_key_array_value_dict)
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