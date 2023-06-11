--- @type ItemSpecifier
InputMethodItemSpecifier = {
  type = "input-method",
  properties = {
    getables = {
      ["to-string"] = function(self)
        return transf.source_id.language(self:get("c"))
      end,
      ["is-active"] = function(self)
        return is.source_id.active(self:get("c"))
      end,
    },
    doThisables = {
      ["activate"] = function(self)
        dothis.source_id.activate(self:get("c"))
      end,
    }
  }
}

--- @type BoundRootInitializeInterface
function CreateInputMethodItem(method)
  return RootInitializeInterface(InputMethodItemSpecifier, method)
end

