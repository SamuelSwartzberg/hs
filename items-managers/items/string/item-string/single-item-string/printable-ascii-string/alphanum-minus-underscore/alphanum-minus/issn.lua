-- issn means \w+

--- @type ItemSpecifier
IssnItemSpecifier = {
  type = "issn",
  action_table ={
    
  }

}

--- @type BoundNewDynamicContentsComponentInterface
CreateIssnItem = bindArg(NewDynamicContentsComponentInterface, IssnItemSpecifier)