--- @type ItemSpecifier
InputMethodItemSpecifier = {
  type = "input-method",
  properties = {
    getables = {
      ["to-string"] = function(self)
        return transf.source_id.language(self:get("contents"))
      end,
      ["is-active"] = function(self)
        return is.source_id.active(self:get("contents"))
      end,
    },
    doThisables = {
      ["activate"] = function(self)
        dothis.source_id.activate(self:get("contents"))
      end,
    }
  }
}

--- @type BoundRootInitializeInterface
function CreateInputMethodItem(method)
  return RootInitializeInterface(InputMethodItemSpecifier, method)
end

