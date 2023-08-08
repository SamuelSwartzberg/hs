--- @type ItemSpecifier
MenvDirItemSpecifier = {
  type = "menv-dir",
  action_table = {
{
      text = "🎣💰🛄📄 srcenvfl.",
      key = "source-env",
    }
  }
  
}


--- @type BoundNewDynamicContentsComponentInterface
CreateMenvDirItem = bindArg(NewDynamicContentsComponentInterface, MenvDirItemSpecifier)