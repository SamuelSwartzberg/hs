--- @type ItemSpecifier
ApplicationItemSpecifier = {
  type = "application-item",
  properties = {
    getables = {
      ["application-support-dir"] = function(self) -- generally true, but may need to be overwritten in subclasses for some applications
        return env.MAC_APPLICATION_SUPPORT .. "/" .. self:get("contents") .. "/"
      end,
      ["application-dir"] = function(self)
        return "/Applications/" .. self:get("contents") .. ".app/"
      end,
      ["is-title-url-application"] = function(self)
        return valuesContain({"Firefox", "Newpipe"}, self:get("contents"))
      end,
      ["is-hydrus-network"] = function(self)
        return self:get("contents") == "Hydrus Network"
      end,
      ["is-tachiyomi"] = function(self)
        return self:get("contents") == "Tachiyomi"
      end,
      ["is-git"] = function(self)
        return self:get("contents") == "Git"
      end,
      ["is-chat-application"] = function(self)
        return valuesContain({"Discord", "Telegram Lite", "WhatsApp", "Signal", "Facebook"}, self:get("contents"))
      end,
      ["upper-name"] = function (self)
        return self:get("contents"):upper()
      end,
      ["running-application-raw"] = function (self)
        return hs.application.get(self:get("contents"))
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

