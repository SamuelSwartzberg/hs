--- @type ItemSpecifier
ManagedDateProjectDirItemSpecifier = {
  type = "managed-date-project-dir",
  properties = {
    getables = {

    }
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreateManagedDateProjectDirItem = bindArg(NewDynamicContentsComponentInterface, ManagedDateProjectDirItemSpecifier)
