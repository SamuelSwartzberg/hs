--- @type ItemSpecifier
InputMethodItemSpecifier = {
  type = "input-method",
  properties = {
    getables = {
      ["to-string"] = function(self)
        return slice(stringy.split(self:get("contents"), "."), -1, -1)[1]
      end,
      ["is-active"] = function(self)
        return hs.keycodes.currentSourceID() == self:get("contents")
      end,
    },
    doThisables = {
      ["activate"] = function(self)
        hs.keycodes.currentSourceID(self:get("contents"))
        hs.alert.show(self:get("to-string"))
      end,
    }
  }
}

--- @type BoundRootInitializeInterface
function CreateInputMethodItem(method)
  return RootInitializeInterface(InputMethodItemSpecifier, method)
end

