
ArrayOfVolumesSpecifier = {
  type = "array-of-volumes",
  properties = {
    getables = {
      
    },
    doThisables = {
      ["choose-item-and-eject"] = function(self)
        self:doThis("choose-item", function(item) 
          item:doThis("eject") 
        end)
      end,
    },
  },
  action_table = {},
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfVolumes = bindArg(NewDynamicContentsComponentInterface, ArrayOfVolumesSpecifier)