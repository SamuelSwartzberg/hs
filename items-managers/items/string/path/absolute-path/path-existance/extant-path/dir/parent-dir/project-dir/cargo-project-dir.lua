--- @type ItemSpecifier
CargoProjectDirItemSpecifier = {
  type = "cargo-project-dir",
  action_table = {
  
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateCargoProjectDirItem = bindArg(NewDynamicContentsComponentInterface, CargoProjectDirItemSpecifier)