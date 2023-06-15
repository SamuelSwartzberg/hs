PosIntSpecifier = {
  type = "pos-int",
  properties = {
    getables = {
      ["get-random-pos-int-of-length"] = function(self)
        return rand(self:get("c"))
      end,
      ["get-random-base64-of-length"] = function(self)
        return rand(self:get("c"), "b64")
      end,
      ["get-random-alphanum-of-length"] = function(self)
        local basis = rand(nil, "b64")
        local filtered = basis:gsub("[^%d%a]", "")
        local truncated = filtered:sub(1, self:get("c"))
        return truncated
      end,
      ["get-random-lower-alphanum-of-length"] = function(self)
        local basis = rand(nil, "b64")
        local filtered = basis:gsub("[^%d%l]", "")
        local truncated = filtered:sub(1, self:get("c"))
        return truncated
      end,
      ["to-base"] = function(self, base)
        return string.format("%" .. base, self:get("c"))
      end,
      ["to-unicode-codepoint"] = function(self)
        return string.format("U+%x", self:get("c"))
      end,
      ["codepoint-to-unicode-prop-table"] = function(self)
        return dc(transf.number.unicode_prop_table(self:get("c")))
      end,
      ["utf8-to-unicode-prop-table"] = function(self)
        return dc(transf.number.utf8_unicode_prop_table(self:get("c")))
      end,
    },
    doThisables = {
      
    }
  },
  
  action_table = {

  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePosInt = bindArg(RootInitializeInterface, PosIntSpecifier)