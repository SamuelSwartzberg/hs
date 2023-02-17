--- @type ItemSpecifier
DiaryDirItemSpecifier = {
  type = "diary-dir",
  properties = {
    getables = {
      
    },
  },
  
}


--- @type BoundNewDynamicContentsComponentInterface
CreateDiaryDirItem = bindArg(NewDynamicContentsComponentInterface, DiaryDirItemSpecifier)