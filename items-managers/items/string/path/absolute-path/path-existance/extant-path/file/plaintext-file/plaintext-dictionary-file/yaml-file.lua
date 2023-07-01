

--- @type ItemSpecifier
YamlFileItemSpecifier = {
  type = "yaml-file",
  properties = {
    getables = {
      ["parse-to-lua-table"] = bc(transf.yaml_file.not_userdata_or_function)
    },
    doThisables = {
      
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateYamlFileItem = bindArg(NewDynamicContentsComponentInterface, YamlFileItemSpecifier)