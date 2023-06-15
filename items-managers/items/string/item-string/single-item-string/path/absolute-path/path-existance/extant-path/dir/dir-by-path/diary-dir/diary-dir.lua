--- @type ItemSpecifier
DiaryDirItemSpecifier = {
  type = "diary-dir",
}


--- @type BoundNewDynamicContentsComponentInterface
CreateDiaryDirItem = bindArg(NewDynamicContentsComponentInterface, DiaryDirItemSpecifier)