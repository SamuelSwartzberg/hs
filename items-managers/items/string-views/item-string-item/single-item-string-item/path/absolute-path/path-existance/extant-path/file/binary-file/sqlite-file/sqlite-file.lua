--- @type ItemSpecifier
SqliteFileItemSpecifier = {
  type = "sqlite-file",
  properties = {
    getables = {
      ["get-export-csv-filename"] = function(self, query)
        return self:get("leaf-without-extension") .. "_" .. eutf8.lower(replace(query, to.case.snake)) .. ".csv"
      end,
      ["get-export-csv-path"]  = function(self, query)
        return env.TMPDIR .. "/" .. self:get("get-export-csv-filename", query)
      end,
      ["command-write-to-csv"] = function(self, specifier)
        return {
          "sqlite3",
          "-header",
          "-csv",
          {
            value = self:get("contents"),
            type = "quoted"
          },
          {
            value = specifier.query,
            type = "quoted"
          },
          ">",
          {
            value = specifier.output_path or self:get("get-export-csv-path", specifier.query),
            type = "quoted"
          }
        }
      end,
      ["is-firefox-places-sqlite-file"] = function(self)
        return stringy.endswith(self:get("contents"), "places.sqlite")
      end,
      ["is-newpipe-sqlite-file"] = function(self)
        return stringy.endswith(self:get("contents"), "newpipe.db")
      end,
    },
    doThisables = {
      ["write-to-csv"] = function(self, specifier)
        run(self:get("command-write-to-csv", specifier), specifier.do_after)
      end,
    },
  },
  potential_interfaces = ovtable.init({
    { key = "firefox-places-sqlite-file", value = CreateFirefoxPlacesSqliteFileItem },
    { key = "newpipe-sqlite-file", value = CreateNewpipeSqliteFileItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateSqliteFileItem = bindArg(NewDynamicContentsComponentInterface, SqliteFileItemSpecifier)