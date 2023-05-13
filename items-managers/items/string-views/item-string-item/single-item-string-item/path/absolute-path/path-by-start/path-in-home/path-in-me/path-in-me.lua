--- @type ItemSpecifier
PathInMeItemSpecifier = {
  type = "path-in-me-item",
  properties = {
    getables = {
      ["is-path-in-maudiovisual"] = function (self)
        return stringy.startswith(self:get("completely-resolved-path"), env.MAUDIOVISUAL)
      end,
      ["is-path-in-mspec"] = function (self)
        return stringy.startswith(self:get("completely-resolved-path"), env.MSPEC)
      end,
      ["local-server-path"] = function(self)
        local path = self:get("completely-resolved-path")
        return path:gsub(env.ME, env.FS_HTTP_SERVER)
      end,
    },
    doThisables = {
     
    }
  },
  potential_interfaces = ovtable.init({
    { key = "path-in-maudiovisual", value = CreatePathInMaudiovisualItem },
    { key = "path-in-mspec", value = CreatePathInMspecItem },
  }),
  action_table = concat(getChooseItemTable({
    {
      description = "srvpth",
      emoji_icon = "🚚",
      key = "local-server-path",
    }
  }),{})
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathInMeItem = bindArg(NewDynamicContentsComponentInterface, PathInMeItemSpecifier)