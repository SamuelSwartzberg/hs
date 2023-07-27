--- @type ItemSpecifier
PathInHomeItemSpecifier = {
  type = "path-in-home",
  properties = {
    getables = {
      ["is-path-in-me"] = function (self)
        return stringy.startswith(self:get("completely-resolved-path"), env.ME)
      end,
      ["is-path-in-screenshots"] = function (self)
        return stringy.startswith(self:get("completely-resolved-path"), env.SCREENSHOTS)
      end,
    },
    doThisables = {
     
    }
  },
  ({
    { key = "path-in-me", value = CreatePathInMeItem },
    { key = "path-in-screenshots", value = CreatePathInScreenshotsItem },
  }),
  action_table = {
    {
      d = "httpsrvurl",
      i = "💻🌐🏠🔗",
      getfn = transf.absolute_path.local_http_server_url
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathInHomeItem = bindArg(NewDynamicContentsComponentInterface, PathInHomeItemSpecifier)