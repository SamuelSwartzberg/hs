--- @type ItemSpecifier
ApplicationItemSpecifier = {
  type = "application",
  properties = {
    getables = {
      ["backup-timer"] = function(self)
        return {
          interval = self:get("backup-interval"),
          fn = function()
            if self:get("backup-no-check-running") or not self:get("is-running") then
              self:doThis("backup-application")
            end
          end,
        }
      end,
    },
  },
  ({
    { key = "title-url-application", value = CreateTitleUrlApplicationItem },
    { key = "hydrus-network", value = CreateHydrusNetworkItem },
    { key = "tachiyomi", value = CreateTachiyomiItem },
    { key = "git", value = CreateGitItem },
    { key = "chat-application", value = CreateChatApplicationItem },
  }),
 

}

--- @type BoundRootInitializeInterface
function CreateApplicationItem(app_name)
  return RootInitializeInterface(ApplicationItemSpecifier, app_name)
end

