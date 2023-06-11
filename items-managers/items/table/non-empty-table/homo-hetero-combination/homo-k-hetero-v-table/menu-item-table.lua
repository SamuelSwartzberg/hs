--- @type ItemSpecifier
MenuItemTableSpecifier = {
  type = "menu-item-table",
  properties = {
    getables = {
      ["path-string"] = function(self)
        return stringx.join(" > ", self:get("contents").path) 
      end,
      ["full-path"] = function(self)
        return concat(self:get("contents").path, {self:get("contents").AXTitle})
      end,
      ["full-path-string"] = function (self)
        local prefix = self:get("path-string")
        if prefix then prefix = prefix .. " > " end
        return (prefix or "") .. self:get("contents").AXTitle
      end,
      ["to-string"] = function (self)
        local outstr = self:get("full-path-string")
        local hotkey_str = self:get("modifier-symbols-and-hotkey-str")
        if hotkey_str then
          outstr = outstr .. " (" .. hotkey_str .. ") "
        end
        return outstr
      end,
      ["modifiers"] = function (self)
        return self:get("contents").AXMenuItemCmdModifiers
      end,
      ["modifier-symbols"] = function(self)
        return map(self:get("modifiers"), tblmap.mod.symbol)
      end,
      ["hotkey"] = function (self)
        return self:get("contents").AXMenuItemCmdChar
      end,
      ["modifier-symbols-and-hotkey-str"] = function (self)
        return join.modifier_array.key.shortcut_string(self:get("modifiers"), self:get("hotkey"))
      end,
        
      
    },
    doThisables = {
      ["exec"] = function(self)
        self:get("contents").application:selectMenuItem(self:get("full-path"))
      end,
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateMenuItemTable = bindArg(NewDynamicContentsComponentInterface, MenuItemTableSpecifier)
