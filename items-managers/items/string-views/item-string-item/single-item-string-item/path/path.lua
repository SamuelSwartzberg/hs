--- @type ItemSpecifier
PathItemSpecifier = {
  type = "path",
  properties = {
    getables = {
      ["is-absolute-path"] = function(self) return self:get("contents"):find("^/") or self:get("contents"):find("^~") end,
      ["is-relative-path"] = function(self) return not self:get("is-absolute-path") end,
      ["is-path-leaf"] = function(self) return #self:get("path-components") > 0 end,
      ["is-in-path"] = function(self, path) return stringy.startswith(self:get("contents"), path) end,
      ["path"] = function(self)
        return self:get("contents")
      end,
      ["path-components"] = function (self)
        return listFilter(
          stringy.split(self:get("path"), "/"),
          function(v)
            return v ~= ""
          end
        )
      end,
      ["parent-path-components"] = function(self)
        local path_components = self:get("path-components")
        listPop(path_components)
        return path_components
      end,
      ["parent-dir-name"] = function(self)
        return self:get("parent-path-components")[#self:get("parent-path-components")]
      end,
      ["parent-dir-path"] = function(self)
        return "/" .. table.concat(self:get("parent-path-components"), "/")
      end,
      ["path-ensure-final-slash"] = function(self)
        return ensureAdfix(self:get("contents"), "/", true, false, "suf")
      end,
      ["path-without-extension"] = function(self)
        return getPathWithoutExtension(self:get("contents"))
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
