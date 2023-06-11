--- @type ItemSpecifier
ApplicationItemSpecifier = {
  type = "application",
  properties = {
    getables = {
      ["application-support-dir"] = function(self) -- generally true, but may need to be overwritten in subclasses for some applications
        return env.MAC_APPLICATION_SUPPORT .. "/" .. self:get("c") .. "/"
      end,
      ["application-dir"] = function(self)
        return "/Applications/" .. self:get("c") .. ".app/"
      end,
      ["is-title-url-application"] = function(self)
        return find({"Firefox", "Newpipe"}, self:get("c"))
      end,
      ["is-hydrus-network"] = function(self)
        return self:get("c") == "Hydrus Network"
      end,
      ["is-tachiyomi"] = function(self)
        return self:get("c") == "Tachiyomi"
      end,
      ["is-git"] = function(self)
        return self:get("c") == "Git"
      end,
      ["is-chat-application"] = function(self)
        return find({"Discord", "Telegram Lite", "WhatsApp", "Signal", "Facebook"}, self:get("c"))
      end,
      ["upper-name"] = function (self)
        return self:get("c"):upper()
      end,
      ["running-application-raw"] = function (self)
        return hs.application.get(self:get("c"))
      end,
      ["running-application-item"] = function (self)
        return CreateRunningApplicationItem(self:get("running-application-raw"))
      end,
      ["is-running"] = function(self)
        return not not self:get("running-application-raw")
      end,
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
  potential_interfaces = ovtable.init({
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

