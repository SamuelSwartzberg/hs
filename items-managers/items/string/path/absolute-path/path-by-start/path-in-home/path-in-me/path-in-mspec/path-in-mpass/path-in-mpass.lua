--- @type ItemSpecifier
PathInMpassItemSpecifier = {
  type = "path-in-mpass",
  properties = {
    getables = {
      ["is-path-in-mpassotp"] = bc(stringy.startswith, env.MPASSOTP),
      ["is-path-in-mpasspassw"] = bc(stringy.startswith, env.MPASSPASSW)
    },
    doThisables = {
     
    }
  },
  potential_interfaces = ovtable.init({
    { key = "path-in-mpassotp", value = CreatePathInMpassotpItem },
    { key = "path-in-mpasspassw", value = CreatePathInMpasspasswItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathInMpassItem = bindArg(NewDynamicContentsComponentInterface, PathInMpassItemSpecifier)