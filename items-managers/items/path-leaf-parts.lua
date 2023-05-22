--- @alias path_leaf_parts { ["general-name"]: string, tag: table<string, string|string[]>, extension: string, path: string } 

--- @type ItemSpecifier
PathLeafPartsSpecifier = {
  type = "path-leaf-parts",
  properties = {
    getables = {
      ["general-name-as-string"] = function(self)
        if self:get("contents")["general-name"] then 
          return "--" .. self:get("contents")["general-name"]
        else
          return ""
        end
      end,
      ["tags-as-string-array"] = function(self)
        local arr = map(
            self:get("contents").tag,
            function(tag_key, tag_value)
              if type(tag_value) == "table" then tag_value = table.concat(tag_value, ",") end
              return false, string.format("%s-%s", tag_key, tag_value)
            end,
            {{"k", "v"}}
          )
        table.sort(arr)
        return arr
      end,
      ["tag-as-string"] = function(self)
        return "%" .. table.concat(self:get("tags-as-string-array"), "%")
      end,
      ["extension-as-string"] = function(self)
        return self:get("contents").extension and "." .. self:get("contents").extension or ""
      end,
      ["path-as-string"] = function(self)
        return mustEnd(self:get("contents").path or "", "/")
      end,
      ["date"] = function(self)
        return self:get("contents").date or ""
      end,
      ["path-leaf-parts-as-string"] = function(self)
        return self:get("path-as-string")
          .. self:get("date")
          .. self:get("general-name-as-string")
          .. self:get("tag-as-string")
          .. self:get("extension-as-string")
      end,
    },
    doThisables = {
    },
  },
  
  action_table = {}
  
}

--- @type BoundRootInitializeInterface
CreatePathLeafParts = bindArg(RootInitializeInterface, PathLeafPartsSpecifier)