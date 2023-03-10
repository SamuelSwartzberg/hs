-- it's ok to use builtin regexes instead of eutf8 regexes for path leaves, since I guarantee that path leaves are ascii

--- @type ItemSpecifier
PathLeafSpecifier = {
  type = "path-leaf",
  properties = {
    getables = {
      ["path-leaf"] = function(self)
        return pathSlice(self:get("contents", "-1:-1")[1])
      end,
      ["to-path-leaf-parts"] = function(self)
        return CreatePathLeafParts({
          ["general-name"] = self:get("path-leaf-general-name"),
          tag = self:get("path-leaf-tags"),
          extension = self:get("path-leaf-extension"),
          path = self:get("parent-dir-path"),
          date = self:get("path-leaf-date"),
        })
      end,
      ["with-path-leaf-part-substituted"] = function(self, specifier)
        local parts = self:get("to-path-leaf-parts")
        parts:get("contents")[specifier.key] = specifier.value
        return parts:get("path-leaf-parts-as-string")
      end,
      
      ["path-leaf-no-date"] = function(self)
        return self:get("path-leaf"):match("^.-%-%-(.*)$") or self:get("path-leaf")
      end,
  
      
      ["is-usable-as-filetype"] = function(self, filetype)
        return isUsableAsFiletype(self:get("path-leaf-extension"), filetype)
      end,
      ["leaf-without-extension"] = function (self)
        return pathSlice(self:get("contents"), "-2:-2", { ext_sep = true } )[1]
      end,

      ["path-leaf-starts-with"] = function(self, prefix)
        return stringy.startswith(self:get("path-leaf"), prefix)
      end,

      ["is-path-leaf-date"] = function(self)
        local path_leaf =  self:get("path-leaf")
        if not memoize(onig.match)(path_leaf,"^\\d") then return false end 
        local date_part = memoize(stringx.split)(path_leaf, "--")[1]
        local parts = memoize(stringx.split)(date_part, "_to_")
        return memoize(onig.find)(parts[1],  whole(mt._r.date.rfc3339._r)) and (not parts[2] or memoize(onig.find)(parts[2],  whole(mt.date.rfc3339)))
      end,
      ["is-path-leaf-general-name"] = function(self) 
        local path_leaf =  self:get("path-leaf")
        return 
          path_leaf:match("^%D") -- string starts with non-digit
          or 
          path_leaf:match("%-%-") -- string contains --
       end,
      ["is-path-leaf-tags"] = function(self) return stringy.find(self:get("contents"), "%") end,
      ["is-path-leaf-extension"] = function(self)
        return pathSlice(self:get("contents"), "-1:-1", { ext_sep = true } ) ~= ""
      end,

      ["windows-with-path-leaf-as-title"] = function(self)
        local res = hs.window.find(self:get("path-leaf"))
        if type(res) == "table" then return res 
        else return {res} end
      end,
      ["windows-of-app-with-path-leaf-as-title"] = function(self, apps)
        if type(apps) == "string" then apps = {apps} end
        local filter = hs.window.filter.new(apps)
        return filter:getWindows()[self:get("path-leaf")]
      end,
      ["window-items-path-leaf-as-title"] = function(self)
        return map(self:get("windows-with-path-leaf-as-title"), function(window)
          return CreateWindowlikeItem(window)
        end)
      end,
      ["window-items-of-app-path-leaf-as-title"] = function(self, apps)
        return map(self:get("windows-of-app-with-path-leaf-as-title", apps), function(window)
          return CreateWindowlikeItem(window)
        end)
      end,
      
    },
    doThisables = {
      ["move-to-path-leaf-part-substituted"] = function(self, specifier)
        local new_path = self:get("with-path-leaf-part-substituted", specifier)
        
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "path-leaf-date", value = CreatePathLeafDate },
    { key = "path-leaf-general-name", value = CreatePathLeafGeneralName },
    { key = "path-leaf-tags", value = CreatePathLeafTags },
    { key = "path-leaf-extension", value = CreatePathLeafExtension },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathLeaf = bindArg(NewDynamicContentsComponentInterface, PathLeafSpecifier)