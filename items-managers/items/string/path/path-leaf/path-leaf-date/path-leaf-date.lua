--- @type ItemSpecifier
PathLeafDateSpecifier = {
  type = "path-leaf-date",
  properties = {
    getables = {
      ["path-leaf-date"] = function(self)
        local path_leaf =  self:get("path-leaf")
        return 
          path_leaf:match("^(.-)%-%-") 
          or path_leaf:match("^(%d[^%%]+)") 
        end,
      ["is-path-leaf-date-range"] = function(self)
        return eutf8.match(self:get("path-leaf-date"), "_to_")
      end,
      ["path-leaf-single-date"] = function(self)
        return not eutf8.match(self:get("path-leaf-date"), "_to_")
      end,
      ["largest-date-to-date"] = function(self)
        return st(self:get("largest-date"))
      end,
      ["smallest-date-to-date"] = function(self)
        return st(self:get("smallest-date"))
      end,
      ["largest-date-to-date-obj"] = function(self)
        return date(self:get("largest-date"))
      end,
      ["smallest-date-to-date-obj"] = function(self)
        return date(self:get("smallest-date"))
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "path-leaf-date-range", value = CreatePathLeafDateRange },
    { key = "path-leaf-single-date", value = CreatePathLeafSingleDate },
    
  })
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathLeafDate = bindArg(NewDynamicContentsComponentInterface, PathLeafDateSpecifier)
