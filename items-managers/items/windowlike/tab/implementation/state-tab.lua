-- contents is the kind of object in the json file provided by ff

--- @type ItemSpecifier
StateTabItemSpecifier = {
  type = "state-tab",
  properties = {
    getables = {
      ["current-hist-attrs"] = function(self)
        local hist_entries = self:get("contents").entries
        return hist_entries[#hist_entries]
      end,
      ["raw-title"] = function(self)
        return self:get("current-hist-attrs").title
      end,
      ["running-application"] = function(self)
        return self:get("contents").app
      end,
      ["index"] = function (self)
        return self:get("contents").index
      end,
      ["window"] = function(self) -- we injected window into the object when creating this
        return self:get("contents").window
      end,
      ["url"] = function (self)
        return self:get("current-hist-attrs").url
      end,
    },
    doThisables = {
      ["close"] = function(self)
        -- not sure this is currently possible
      end,
      ["make-main"] = function(self)
        -- not sure this is currently possible
      end,
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateStateTabItem = bindArg(NewDynamicContentsComponentInterface, StateTabItemSpecifier)

