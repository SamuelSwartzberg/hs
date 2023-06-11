--- @type ItemSpecifier
NewpipeItemSpecifier = {
  type = "newpipe",
  properties = {
    getables = {
      ["backup-sqlite"] = function(self)
        return env.NEWPIPE_STATE_DIR .. "/newpipe.db"
      end,
      ["backup-sqlite-file-string-item"] = function(self)
        return st(self:get("backup-sqlite"))
      end,
      ["backup-csv-file-path"] = function(self)
        return env.TMP_NEWPIPE_HISTORY_CSV
      end,
      ["backup-path"] = function(self)
        return env.MMEDIA_LOGS
      end,
    },
    doThisables = {
      ["pre-backup"] = function(self, do_after)
        run({
          "cd",
          { value = "$NEWPIPE_STATE_DIR", type = "quoted" },
          "&&",
          "unzip",
          "*.zip",
          "&&",
          "rm",
          "*.zip *.settings",
        }, do_after)
      end,
    }
  },
  
 

}

--- @type BoundNewDynamicContentsComponentInterface
CreateNewpipeItem = bindArg(NewDynamicContentsComponentInterface, NewpipeItemSpecifier)