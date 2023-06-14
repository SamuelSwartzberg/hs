--- @type ItemSpecifier
PathInterfaceItemSpecifier = {
  type = "absolute-path",
  properties = {
    getables = {
      ["is-tilde-absolute-path"] = function(self) return self:get("c"):find("^~") end,
      ["is-true-absolute-path"] = function(self) return self:get("c"):find("^/") end,
      ["is-extant-path"] = bc(is.path.exists),
      ["is-non-extant-path"] = bc(is.path.does_not_exist),
      ["is-volume"] = bc(is.path.volume),
      ["is-path-by-start"] = returnTrue,
      ["relative-path-from"] = function(self, starting_point)
        starting_point = starting_point or env.HOME
        return self:get("difference-from-prefix-or-nil", mustEnd(starting_point, "/"))
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
  action_table ={
    {
      d = "httpsrvurl",
      i = "💻🌐🏠🔗",
      getfn = transf.absolute_path.local_http_server_url
    },{
      d = "flurl",
      i = "📄🔗",
      getfn = transf.absolute_path.file_url
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateAbsolutePathItem = bindArg(NewDynamicContentsComponentInterface, PathInterfaceItemSpecifier)
