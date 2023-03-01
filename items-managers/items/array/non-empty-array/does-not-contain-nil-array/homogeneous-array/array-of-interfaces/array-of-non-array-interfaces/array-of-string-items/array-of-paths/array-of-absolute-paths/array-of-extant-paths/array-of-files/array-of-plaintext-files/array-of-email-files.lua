
ArrayOfEmailFilesSpecifier = {
  type = "array-of-email-files",
  properties = {
    getables = {
      ["to-summary-line-path-table"] = function(self)
        local raw_table = mapPairNewPairOvtable(self:get("contents"), function(_, path)
          return path:get("contents"), path:get("email-summary")
        end)
        return CreateTable(raw_table)
      end,
    },
    doThisables = {
      ["to-summary-line-path-table-parallel"] = function(self, do_after)
        runHsTaskNThreadsOnArray(self:get("contents"), function(_, path)
          return path:get("contents"), path:get("email-summary-task")
        end, function(raw_summary_path_table)
          map(raw_summary_path_table, function(text)
            return stringy.strip(text)
          end)
          do_after(CreateTable(raw_summary_path_table))
        end)
      end,
      ["to-summary-line-body-path-table-parallel"] = function(self, do_after)
        runHsTaskNThreadsOnArray(self:get("contents"), function(_, path)
          return path:get("contents"), {
            "echo ",
            { value = path:get("email-summary-task"), type = "interpolated"},
            { value = path:get("email-body-rendered-task"), type = "interpolated"},
          }
        end, function(raw_summary_path_table)
          raw_summary_path_table = map(raw_summary_path_table, function(text)
            return stringx.shorten(text, 500)
          end)
          do_after(CreateTable(raw_summary_path_table))
        end)
      end,
      ["choose-email-and-then-action-parallel"] = function(self)
        self:doThis("to-summary-line-path-table-parallel", function(table)
          table:doThis("choose-value-act-on-key", function(email)
            CreateStringItem(email):doThis("choose-action")
          end)
        end)
      end,
      ["choose-email-and-then-action"] = function(self)
        self:get("to-summary-line-path-table"):doThis("choose-value-act-on-key", function(email)
          CreateStringItem(email):doThis("choose-action")
        end)
      end,

    },
  },
  action_table = {},
  
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfEmailFiles = bindArg(NewDynamicContentsComponentInterface, ArrayOfEmailFilesSpecifier)