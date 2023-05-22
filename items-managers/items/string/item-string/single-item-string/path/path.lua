--- @type ItemSpecifier
PathItemSpecifier = {
  type = "path",
  properties = {
    getables = {
      ["is-absolute-path"] = function(self) 
        return stringy.startswith(self:get("contents"), "/") or stringy.startswith(self:get("contents"), "~")
      end,
      ["is-relative-path"] = function(self) return not self:get("is-absolute-path") end,
      ["is-path-leaf"] = returnTrue,
      ["is-in-path"] = function(self, path) return stringy.startswith(self:get("resolved-path"), path) end,
      ["resolved-path"] = function(self)
        return transf.string.path_resolved(self:get("contents"))
      end,
      ["parent-dir-name"] = function(self)
        return pathSlice(self:get("resolved-path"), "-2:-2")[1]
      end,
      ["parent-dir-path"] = function(self)
        return pathSlice(self:get("resolved-path"), ":-2", {rejoin_at_end=true})
      end,
      ["path-ensure-final-slash"] = function(self)
        return mustEnd(self:get("resolved-path"), "/")
      end,
      ["path-without-extension"] = function(self)
        return pathSlice(self:get("resolved-path"), ":-2", { ext_sep = true, reojoin_at_end = true })[1]
      end,
      ["full-audiovisual"] = function(self, fkey)
        local outstr = self:get("path-leaf-tags-audiovisual")
        if not outstr or outstr == "" then
          outstr = self:get("path-leaf")
        end
        return outstr
      end
    }
  },
  potential_interfaces = ovtable.init({
    { key = "absolute-path", value = CreateAbsolutePathItem },
    { key = "relative-path", value = CreateRelativePathItem },
    { key = "path-leaf", value = CreatePathLeaf },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathItem = bindArg(NewDynamicContentsComponentInterface, PathItemSpecifier)
