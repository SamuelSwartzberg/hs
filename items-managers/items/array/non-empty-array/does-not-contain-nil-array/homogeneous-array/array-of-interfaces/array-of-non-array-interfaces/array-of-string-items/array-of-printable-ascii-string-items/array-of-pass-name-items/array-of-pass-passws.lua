
ArrayOfPassPasswItemsSpecifier = {
  type = "array-of-pass-passws",
  properties = {
    getables = {
      
    },
    doThisables = {
      ["choose-and-fill-pass"] = function(self)
        self:doThis("choose-item", function(item) 
          item:doThis("paste-result-of-get", {key = "pass-passw"})
        end)
      end,
    },
  },
  action_table = {},
  
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfPassPasswItems = bindArg(NewDynamicContentsComponentInterface, ArrayOfPassPasswItemsSpecifier)