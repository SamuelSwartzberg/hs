--- @type ItemSpecifier
DbFileItemSpecifier = {
  type = "db-file",
  properties = {
    getables = {
      ["get-export-csv-filename"] = function(self, query)
        return self:get("leaf-without-extension") .. "_" .. eutf8.lower(replace(query, to.case.snake)) .. ".csv"
      end,
      ["get-export-csv-path"]  = function(self, query)
        return env.TMPDIR .. "/" .. self:get("get-export-csv-filename", query)
      end,
      ["is-sql-file"] = function(self)
        return is.path.usable_as_filetype(self:get("contents"), "possibly-sql")
      end,
    },
    doThisables = {
      ["write-to-csv"] = function(self, specifier)
        run(self:get("command-write-to-csv", specifier), specifier.do_after)
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "sql-file", value = CreateSqlFileItem },
  }),
  action_table = {},
}

--- @type BoundNewDynamicContentsComponentInterface
CreateDbFileItem = bindArg(NewDynamicContentsComponentInterface, DbFileItemSpecifier)