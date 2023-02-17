

--- @type ItemSpecifier
TomlFileItemSpecifier = {
  type = "toml-file",
  properties = {
    getables = {
      ["parse-to-lua-table"] = function(self)
        return toml.decode(self:get("file-contents"))
      end,
      ["lua-table-to-string"] = function(_, tbl)
        return toml.encode(tbl)
      end,
    },
    doThisables = {
      
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateTomlFileItem = bindArg(NewDynamicContentsComponentInterface, TomlFileItemSpecifier)