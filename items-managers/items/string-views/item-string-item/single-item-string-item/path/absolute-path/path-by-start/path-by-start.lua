--- @type ItemSpecifier
PathByStartItemSpecifier = {
  type = "path-by-start-item",
  properties = {
    getables = {
      ["is-path-in-home"] = function(self)
        return stringy.startswith(self:get("contents"), env.HOME)
      end,
      ["is-path-not-in-home"] = function(self)
        return not self:get("is-path-in-home")
      end,
      ["relative-path"] = function(self)
        return ensureAdfix(self:get("contents"), self:get("base-path"), false)
      end,
    },
    doThisables = {
     
    }
  },
  potential_interfaces = ovtable.init({
    { key = "path-in-home", value = CreatePathInHomeItem },
    { key = "path-not-in-home", value = CreatePathNotInHomeItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathByStartItem = bindArg(NewDynamicContentsComponentInterface, PathByStartItemSpecifier)