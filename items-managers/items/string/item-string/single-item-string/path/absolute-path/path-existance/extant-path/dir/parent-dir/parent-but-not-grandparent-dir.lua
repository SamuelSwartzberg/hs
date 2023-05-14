--- @type ItemSpecifier
ParentButNotGrandparentDirItemSpecifier = {
  type = "parent-but-not-grandparent-dir",
  properties = {

    getables = {
      ["descendant-string-array"] = function(self) return self:get("child-string-array") end,
    },
  
    doThisables = {
      ["choose-descendant"] = function(self) self:get("choose-child") end,
      ["choose-descendant-file"] = function(self) self:get("choose-child-file") end,
      ["choose-descendant-dir"] = function(self) self:get("choose-child-dir") end,
      ["choose-descendant-string-item-dir"]  = function(self) self:get("choose-child-string-item-dir") end
    }
  },
  action_table = {
  }
}


--- @type BoundNewDynamicContentsComponentInterface
CreateParentButNotGrandparentDirItem = bindArg(NewDynamicContentsComponentInterface, ParentButNotGrandparentDirItemSpecifier)