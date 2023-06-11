UnicodePropTableSpecifier = {
  type = "unicode-prop-table",
  properties = {
    getables = {
      ["to-string"] = function(self)
        local contents = self:get("c")
        return contents.char .. ": "  .. contents.cpoint .. " " .. contents.name ..
          "(cat: " .. contents.category .. ")"
      end,
      ["category"] = function(self)
        return self:get("c").cat
      end,
      ["char"] = function(self)
        return self:get("c").char
      end,
      ["cpoint"] = function(self)
        return self:get("c").cpoint
      end,
      ["name"] = function(self)
        return self:get("c").name
      end,
      ["html"] = function(self)
        return self:get("c")["html"]
      end,
      ["decimal-codepoint"] = function(self)
        return self:get("c")["dec"]
      end,
      ["eutf8"] = function(self)
        return self:get("c")["eutf8"]
      end,
    },
    doThisables = {
   
    },
  },
  
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateUnicodePropTable = bindArg(NewDynamicContentsComponentInterface, UnicodePropTableSpecifier)
