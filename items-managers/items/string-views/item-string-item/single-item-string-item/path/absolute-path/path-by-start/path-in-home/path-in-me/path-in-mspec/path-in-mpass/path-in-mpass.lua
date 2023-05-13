--- @type ItemSpecifier
PathInMpassItemSpecifier = {
  type = "path-in-mpass",
  properties = {
    getables = {
      ["is-path-in-mpassotp"] = function(self)
        return stringy.startswith(self:get("completely-resolved-path"), env.MPASSOTP)
      end,
      ["is-path-in-mpasspassw"] = function(self)
        return stringy.startswith(self:get("completely-resolved-path"), env.MPASSPASSW)
      end,
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