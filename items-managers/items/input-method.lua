--- @type ItemSpecifier
InputMethodItemSpecifier = {
  type = "input-method-item",
  properties = {
    getables = {
      ["to-string"] = function(self)
        return listSlice(stringy.split(self:get("contents"), "."), -1, -1)[1]
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
function CreateInputMethodItem(hs_application)
  return RootInitializeInterface(InputMethodItemSpecifier, hs_application)
end

