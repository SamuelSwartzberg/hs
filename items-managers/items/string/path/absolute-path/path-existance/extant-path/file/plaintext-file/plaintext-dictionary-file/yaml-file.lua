

--- @type ItemSpecifier
YamlFileItemSpecifier = {
  type = "yaml-file",
  properties = {
    getables = {
      ["parse-to-lua-table"] = bc(transf.yaml_file.table)
    },
    doThisables = {
      
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateYamlFileItem = bindArg(NewDynamicContentsComponentInterface, YamlFileItemSpecifier)