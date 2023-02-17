
ArrayOfDatedExtantPathsSpecifier = {
  type = "array-of-dated-extant-paths",
  properties = {
    getables = {
     
    },
    doThisables = {
      ["move-to-new-dir-under-date-managed-common-ancestor"] = function(self, name)
        self:doThis("move-to-new-dir-under-common-ancestor", "0000-00-00_to_0000-00-00--" .. name)
      end,
    },
  },
  action_table = {},
  
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfDatedExtantPaths = bindArg(NewDynamicContentsComponentInterface, ArrayOfDatedExtantPathsSpecifier)