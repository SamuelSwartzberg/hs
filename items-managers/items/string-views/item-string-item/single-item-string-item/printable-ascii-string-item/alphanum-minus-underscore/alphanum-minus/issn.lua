-- issn means \w+

--- @type ItemSpecifier
IssnItemSpecifier = {
  type = "issn-item",
  properties = {
    getables = {

    }
  },
  
  action_table ={
    
  }

}

--- @type BoundNewDynamicContentsComponentInterface
CreateIssnItem = bindArg(NewDynamicContentsComponentInterface, IssnItemSpecifier)