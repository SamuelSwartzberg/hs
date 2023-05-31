PosIntSpecifier = {
  type = "pos-int",
  properties = {
    getables = {
      ["get-random-pos-int-of-length"] = function(self)
        return rand(self:get("contents"))
      end,
      ["get-random-base64-of-length"] = function(self)
        return rand(self:get("contents"), "b64")
      end,
      ["get-random-alphanum-of-length"] = function(self)
        local basis = rand(nil, "b64")
        local filtered = basis:gsub("[^%d%a]", "")
        local truncated = filtered:sub(1, self:get("contents"))
        return truncated
      end,
      ["get-random-lower-alphanum-of-length"] = function(self)
        local basis = rand(nil, "b64")
        local filtered = basis:gsub("[^%d%l]", "")
        local truncated = filtered:sub(1, self:get("contents"))
        return truncated
      end,
      ["to-base"] = function(self, base)
        return string.format("%" .. base, self:get("contents"))
      end,
      ["to-unicode-codepoint"] = function(self)
        return string.format("U+%x", self:get("contents"))
      end,
      ["codepoint-to-unicode-prop-table"] = function(self)
        return CreateTable(transf.number.unicode_prop_table(self:get("contents")))
      end,
      ["utf8-to-unicode-prop-table"] = function(self)
        return CreateTable(transf.number.utf8_unicode_prop_table(self:get("contents")))
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