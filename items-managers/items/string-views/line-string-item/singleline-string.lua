

--- @type ItemSpecifier
SinglelineStringItemSpecifier = {
  type = "singleline-string",
  properties = {
    getables = {
      
      
    },
    doThisables = {
      
      
    }
  },

  action_table = 
    concat(
      {
        
      },
      getChooseItemTable({
        
      })
    )
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateSinglelineStringItem = bindArg(NewDynamicContentsComponentInterface, SinglelineStringItemSpecifier)