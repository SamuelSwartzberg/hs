--- @type ItemSpecifier
BinaryFileItemSpecifier = {
  type = "binary-file",
  properties = {
    getables = {
      ["is-db-file"] = function(self)
        return isUsableAsFiletype(self:get("contents"), "db")
      end,
    },
    doThisables = {
    }
  },
  potential_interfaces = ovtable.init({
    { key = "db-file", value = CreateDbFileItem },
  }),
  action_table = {},
}

--- @type BoundNewDynamicContentsComponentInterface
CreateBinaryFileItem = bindArg(NewDynamicContentsComponentInterface, BinaryFileItemSpecifier)