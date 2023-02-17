UnicodePropTableSpecifier = {
  type = "unicode-prop-table",
  properties = {
    getables = {
      ["to-string"] = function(self)
        local contents = self:get("contents")
        return contents.char .. ": "  .. contents.cpoint .. " " .. contents.name ..
          "(cat: " .. contents.category .. ")"
      end,
      ["category"] = function(self)
        return self:get("contents").cat
      end,
      ["char"] = function(self)
        return self:get("contents").char
      end,
      ["cpoint"] = function(self)
        return self:get("contents").cpoint
      end,
      ["name"] = function(self)
        return self:get("contents").name
      end,
      ["html"] = function(self)
        return self:get("contents")["html"]
      end,
      ["decimal-codepoint"] = function(self)
        return self:get("contents")["dec"]
      end,
      ["eutf8"] = function(self)
        return self:get("contents")["eutf8"]
      end,
    },
    doThisables = {
   
    },
  },
  
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateUnicodePropTable = bindArg(NewDynamicContentsComponentInterface, UnicodePropTableSpecifier)
