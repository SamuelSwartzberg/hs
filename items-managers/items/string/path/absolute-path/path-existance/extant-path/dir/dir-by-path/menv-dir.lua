--- @type ItemSpecifier
MenvDirItemSpecifier = {
  type = "menv-dir",
  action_table = {
    {
      text = "📝💰🛄📄 wrtenvfl.",
      dothis = dothis.env_yaml_file_container.write_env_and_check,
    },{
      text = "🎣💰🛄📄 srcenvfl.",
      key = "source-env",
    }
  }
  
}


--- @type BoundNewDynamicContentsComponentInterface
CreateMenvDirItem = bindArg(NewDynamicContentsComponentInterface, MenvDirItemSpecifier)