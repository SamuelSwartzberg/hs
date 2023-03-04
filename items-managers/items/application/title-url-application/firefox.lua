--- @type ItemSpecifier
FirefoxItemSpecifier = {
  type = "firefox-item",
  properties = {
    getables = {
      ["default-profile-dir"] = function(self)
        return self:get("application-support-dir") .. "Profiles/wx58dsmn.default-release/"
      end,
      ["default-places-sqlite"] = function(self)
        return self:get("default-profile-dir") .. "places.sqlite"
      end,
      ["backup-squlite"] = function(self)
        return self:get("default-places-sqlite")
      end,
      ["backup-csv-file-path"] = function(self)
        return env.TMP_FIREFOX_HISTORY_CSV
      end,
      ["backup-path"] = function(self)
        return env.MBROWSER_LOGS
      end,
      ["state-as-json"] = function(self)
        self:doThis("dump-state") -- todo: temporary, migrate this to be on some timer rather than block here
        local state_raw = readFile(env.TMP_FIREFOX_STATE_JSON)
        if not state_raw then
          error("Could not read state file")
        end
        local state = json.decode(state_raw)
        if not state then
          error("Could not decode state file")
        end
        return state
      end,
      ["backup-interval"] = function(self)
        return 5 * processors.dt_component_seconds_map["minute"]
      end,
    },
    doThisables = {
      ["pre-backup"] = function(self, do_after)
        do_after() -- no pre-backup actions for firefox
      end,
      ["dump-state"] = function (self)
        run({
          "lz4jsoncat",
          { value = "$MAC_FIREFOX_PLACES_SESSIONSTORE_RECOVERY", type = "quoted" },
          ">",
          { value = "$TMP_FIREFOX_STATE_JSON", type = "quoted"}
        }, true)
      end,
      
    }
  },
  
 

}

--- @type BoundNewDynamicContentsComponentInterface
CreateFirefoxItem = bindArg(NewDynamicContentsComponentInterface, FirefoxItemSpecifier)