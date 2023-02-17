--- @type ItemSpecifier
HotkeyItemSpecifier = {
  type = "hotkey-item",
  properties = {
    getables = {
      ["hotkey"] = function(self)
        return self:get("contents").hotkey
      end,
      ["explanation"] = function(self)
        return self:get("contents").explanation
      end,
      ["mnemonic"] = function(self)
        return self:get("contents").mnemonic
      end,
      ["mods"] = function (self)
        return self:get("contents").mods
      end,
      ["key"] = function (self)
        return self:get("contents").key
      end,
      ["to-string"] = function(self)
        local shortcut_str = shortcutToString(self:get("mods"), self:get("key"))
        local pre_colon_str = shortcut_str
        local mnemonic = self:get("mnemonic")
        if mnemonic then
          pre_colon_str = ("%s (%s)"):format(shortcut_str, mnemonic)
        end
        return ("%s: %s"):format(pre_colon_str, self:get("explanation"))
      end,
    },
    doThisables = {
      ["enable"] = function(self)
        self:get("hotkey"):enable()
      end,
      ["disable"] = function(self)
        self:get("hotkey"):disable()
      end,
    }
  }
}

--- @type BoundRootInitializeInterface
function CreateHotkeyItem(specifier)
  function pcallHotkeyFn()
    specifier.fn()
    --[[ local success, result = pcall(specifier.fn)
    if not success then
      hs.alert.show(result)
    end ]]
  end
  specifier.modifiers = specifier.modifiers or {"cmd", "shift", "alt"}
  local hotkey = hs.hotkey.new(specifier.modifiers , specifier.key, pcallHotkeyFn)
  if hotkey == nil then error("hotkey is nil") end
  hotkey:enable()
  return RootInitializeInterface(HotkeyItemSpecifier, {
    hotkey = hotkey,
    explanation = specifier.explanation,
    mnemonic = specifier.mnemonic,
    mods = specifier.modifiers,
    key = specifier.key,
  })
end

