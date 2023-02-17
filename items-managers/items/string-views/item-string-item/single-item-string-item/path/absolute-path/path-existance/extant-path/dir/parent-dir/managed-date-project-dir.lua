--- @type ItemSpecifier
ManagedDateProjectDirItemSpecifier = {
  type = "managed-date-project-dir-item",
  properties = {
    getables = {

    }
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreateManagedDateProjectDirItem = bindArg(NewDynamicContentsComponentInterface, ManagedDateProjectDirItemSpecifier)
