--- @type ItemSpecifier
SqliteFileItemSpecifier = {
  type = "sqlite-file",
  properties = {
    getables = {
      ["is-firefox-places-sqlite-file"] = function(self)
        return stringy.endswith(self:get("completely-resolved-path"), "places.sqlite")
      end,
      ["is-newpipe-sqlite-file"] = function(self)
        return stringy.endswith(self:get("completely-resolved-path"), "newpipe.db")
      end,
    },
    doThisables = {
      
    },
  },
  potential_interfaces = ovtable.init({
    { key = "firefox-places-sqlite-file", value = CreateFirefoxPlacesSqliteFileItem },
    { key = "newpipe-sqlite-file", value = CreateNewpipeSqliteFileItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateSqliteFileItem = bindArg(NewDynamicContentsComponentInterface, SqliteFileItemSpecifier)