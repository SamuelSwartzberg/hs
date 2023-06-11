--- @type ItemSpecifier
DbFileItemSpecifier = {
  type = "db-file",
  properties = {
    getables = {
      ["is-sql-file"] = function(self)
        return is.path.usable_as_filetype(self:get("contents"), "possibly-sql")
      end,
    },
    doThisables = {
    }
  },
  potential_interfaces = ovtable.init({
    { key = "sql-file", value = CreateSqlFileItem },
  }),
  action_table = {},
}

--- @type BoundNewDynamicContentsComponentInterface
CreateDbFileItem = bindArg(NewDynamicContentsComponentInterface, DbFileItemSpecifier)