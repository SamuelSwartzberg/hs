

--- @type ItemSpecifier
YamlFileItemSpecifier = {
  type = "yaml-file",
  properties = {
    getables = {
      ["parse-to-lua-table"] = function(self)
        return yaml.load(self:get("file-contents"))
      end,
      ["lua-table-to-string"] = function(_, tbl)
        return yamlDump(tbl)
      end,
    },
    doThisables = {
      
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateYamlFileItem = bindArg(NewDynamicContentsComponentInterface, YamlFileItemSpecifier)