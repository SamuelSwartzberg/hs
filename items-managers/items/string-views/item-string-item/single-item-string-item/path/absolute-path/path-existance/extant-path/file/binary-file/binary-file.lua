--- @type ItemSpecifier
BinaryFileItemSpecifier = {
  type = "binary-file",
  properties = {
    getables = {
      ["is-sqlite-file"] = function(self)
        return isUsableAsFiletype(self:get("contents"), "possibly-sqlite")
      end,
    },
    doThisables = {
    }
  },
  potential_interfaces = ovtable.init({
    { key = "sqlite-file", value = CreateSqliteFileItem },
  }),
  action_table = {},
}

--- @type BoundNewDynamicContentsComponentInterface
CreateBinaryFileItem = bindArg(NewDynamicContentsComponentInterface, BinaryFileItemSpecifier)