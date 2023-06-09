--- @type ItemSpecifier
Base64DataURLItemSpecifier = {
  type = "base64-data-url",
  properties = {
    getables = {
      
    }, 
    doThisables = {
      
    }
  },

  action_table =concat(getChooseItemTable({
    
  }),{})
}

--- @type BoundNewDynamicContentsComponentInterface
CreateBase64DataURLItem = bindArg(NewDynamicContentsComponentInterface, Base64DataURLItemSpecifier)