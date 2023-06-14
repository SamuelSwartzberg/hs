--- @type ItemSpecifier
PathInterfaceItemSpecifier = {
  type = "absolute-path",
  properties = {
    getables = {
      ["is-tilde-absolute-path"] = function(self) return self:get("c"):find("^~") end,
      ["is-true-absolute-path"] = function(self) return self:get("c"):find("^/") end,
      ["is-extant-path"] = function(self) return testPath(self:get("c")) end,
      ["is-non-extant-path"] = function(self) return not self:get("is-extant-path") end,
      ["is-volume"] = function(self) return stringy.startswith(self:get("c"), "/Volumes/") end,
      ["is-path-by-start"] = returnTrue,
      ["relative-path-from"] = function(self, starting_point)
        starting_point = starting_point or env.HOME
        return self:get("difference-from-prefix-or-nil", mustEnd(starting_point, "/"))
      end,
      ["local-http-server-url"] = function(self)
        return env.FS_HTTP_SERVER .. self:get("completely-resolved-path")
      end,
    },
  },
  potential_interfaces = ovtable.init({
    -- these two must come first, since checking later potential_interfaces depends on them
    { key = "tilde-absolute-path", value = CreateTildeAbsolutePathItem },
    { key = "true-absolute-path", value = CreateTrueAbsolutePathItem },
    -- other potential_interfaces
    { key = "extant-path", value = CreateExtantPathItem },
    { key = "non-extant-path", value = CreateNonExtantPathItem },
    { key = "volume", value = CreateVolumeItem },
    { key = "path-by-start", value = CreatePathByStartItem },
  }),
  action_table = concat(
    {

    },
    getChooseItemTable({
      {
        d = "httpsrvurl",
        i = "💻🌐🏠🔗",
        key = "local-http-server-url",
      },{
        d = "flurl",
        i = "📄🔗",
        key = "file-url",
      }
    })
  )
}

--- @type BoundNewDynamicContentsComponentInterface
CreateAbsolutePathItem = bindArg(NewDynamicContentsComponentInterface, PathInterfaceItemSpecifier)
