PosIntSpecifier = {
  type = "pos-int",
  properties = {
    getables = {
      ["get-random-pos-int-of-length"] = function(self)
        return randomInt(self:get("contents"))
      end,
      ["get-random-base64-of-length"] = function(self)
        return getOutputTask({
          "openssl",
          "rand",
          "-base64",
          self:get("contents")
        })
      end,
      ["get-random-alphanum-of-length"] = function(self)
        local basis = longBase64RandomString()
        local filtered = basis:gsub("[^%d%a]", "")
        local truncated = filtered:sub(1, self:get("contents"))
        return truncated
      end,
      ["get-random-lower-alphanum-of-length"] = function(self)
        local basis = longBase64RandomString()
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
        return  CreateShellCommand("uni"):get("print", self:get("to-unicode-codepoint"))
      end,
      ["eutf8-to-unicode-prop-table"] = function(self)
        return  CreateShellCommand("uni"):get("print", "eutf8:" .. self:get("to-base", "x"))
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