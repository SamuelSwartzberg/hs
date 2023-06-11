--- @type ItemSpecifier
BinaryFileItemSpecifier = {
  type = "binary-file",
  properties = {
    getables = {
      ["is-db-file"] = function(self)
        return is.path.usable_as_filetype(self:get("c"), "db")
      end,
      ["is-playable-file"] = function (self)
        return is.path.playable_file(self:get("c"))
      end
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