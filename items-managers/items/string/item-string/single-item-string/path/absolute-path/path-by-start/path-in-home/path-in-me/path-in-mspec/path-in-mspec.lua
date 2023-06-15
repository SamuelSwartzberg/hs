--- @type ItemSpecifier
PathInMspecItemSpecifier = {
  type = "path-in-mspec",
  properties = {
    getables = {
      ["is-path-in-mpass"] = bc(stringy.startswith, env.MPASS)
    },
    doThisables = {
     
    }
  },
  potential_interfaces = ovtable.init({
    { key = "path-in-mpass", value = CreatePathInMpassItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathInMspecItem = bindArg(NewDynamicContentsComponentInterface, PathInMspecItemSpecifier)