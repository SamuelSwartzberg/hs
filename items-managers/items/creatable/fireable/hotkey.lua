--- @type ItemSpecifier
HotkeyItemSpecifier = {
  type = "hotkey",
  properties = {
    getables = {
      ["hotkey"] = function(self)
        return self:get("contents").hotkey
      end,
      ["explanation"] = function(self)
        return self:get("specifier").explanation
      end,
      ["mnemonic"] = function(self)
        return self:get("specifier").mnemonic
      end,
      ["mods"] = function (self)
        return self:get("specifier").mods
      end,
      ["key"] = function (self)
        return self:get("specifier").key
      end,
      ["to-string"] = function(self)
        local shortcut_str = join.modifier_array.key.shortcut_string(self:get("mods"), self:get("key"))
        local pre_colon_str = shortcut_str
        local mnemonic = self:get("mnemonic")
        if mnemonic then
          pre_colon_str = ("%s (%s)"):format(shortcut_str, mnemonic)
        end
        return ("%s: %s"):format(pre_colon_str, self:get("explanation"))
      end,
      ["created"] = function(self)
        local specifier = self:get("specifier")
        return  hs.hotkey.new(specifier.modifiers , specifier.key, specifier.pcallfn)
      end
    },
    doThisables = {
      ["start"] = function(self)
        self:get("hotkey"):enable()
      end,
      ["stop"] = function(self)
        self:get("hotkey"):disable()
      end,
      ["add-defaults-to-specifier"] = function(self)
        local specifier = self:get("specifier")
        function pcallHotkeyFn()
          specifier.fn()
          --[[ local success, result = pcall(specifier.fn)
          if not success then
            hs.alert.show(result)
          end ]]
        end
        specifier.pcallfn = pcallHotkeyFn
        specifier.key = specifier.key or specifier.speckey
        specifier.modifiers = specifier.modifiers or {"cmd", "shift", "alt"}
      end

    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateHotkeyItem = bindArg(NewDynamicContentsComponentInterface, HotkeyItemSpecifier)