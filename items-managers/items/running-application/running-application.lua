--- @type ItemSpecifier
RunningApplicationItemSpecifier = {
  type = "running-application",
  properties = {
    getables = {
      ["app-window-filter"] = function(self)
        return hs.window.filter.new(nil):setAppFilter(self:get("c"))
      end,
      ["all-windows-by-filter"] = function(self) -- uses filters and therefore goes through spaces
        return self:get("app-window-filter"):getWindows()
      end,
      ["window-index"] = function(self, window)
        local windows = self:get("all-windows")
        return find(windows, function(w) 
          return w:id() == window:id() end, {"v", "k"})
      end,
      ["to-string"] = function(self)
        return self:get("name")
      end,
      ["relevant-application-relative-dir"] = function(self, type)
        return env["M" .. type .. "_APPLICATIONS"] .. "/" .. self:get("name")
      end,
      ["relevant-application-relative-sessions"] = function(self)
        return self:get("str-item", {key = "relevant-application-relative-dir", args = "SESSIONS"}):get("descendant-string-item-array")
      end,
      ["relevant-sessions"] = function(self)
        return glue(self
          :get("relevant-application-relative-sessions"):get("c"), 
            st(env.MSESSIONS .. "/global"):get("descendant-string-item-array")
          )
      end,
    },
    doThisables = {
      ["select-menu-item"] = function(self, item_arr)
        self:get("c"):selectMenuItem(item_arr)
      end,
      ["open-recent"] = function(self, recent_item)
        local command = concat(self:get("open-recent-menu-command"), recent_item)
        self:get("c"):selectMenuItem(command)
      end,
      ["choose-menu-action"] = function(self)
        self:get("menu-item-array"):doThis("choose-item", function(item)
          item:doThis("exec")
        end)
      end,
      ["choose-and-use-relevant-session"] = function (self)
        self:get("relevant-sessions"):doThis("choose-item", function(item)
          self:doThis("load-session", item)
        end)
      end,
      ["focus-main-window"] = function (self)
        self:get("main-window"):focus()
      end
          
    }
  },
  potential_interfaces = ovtable.init({
    { key = "omegat", value = CreateOmegatApplication },
    { key = "libreoffice", value = CreateLibreofficeApplication },
    { key = "browser-application", value = CreateBrowserApplicationApplication },
  }),
  action_table = concat({
    {
      text = "👉📎✂️ cpstsnp.",
      key = "choose-and-use-relevant-snippet",
    }, {
      text = "👉📎✍️ cpstfrm.",
      key = "choose-and-use-relevant-form",
    },  {
      text = "👉🗄📚 copsess.",
      key = "choose-and-use-relevant-session",
    }, {
      text = "🌄✂️ crsnp.",
      key = "do-interactive",
      args = {
        key = "create-relevant-snippet",
        thing = {
          func = "hsPasteboardReadString"
        }
      }
    }
  }, getChooseItemTable({}))
}

--- @type BoundRootInitializeInterface
function CreateRunningApplicationItem(hs_application)
  return RootInitializeInterface(RunningApplicationItemSpecifier, hs_application)
end

