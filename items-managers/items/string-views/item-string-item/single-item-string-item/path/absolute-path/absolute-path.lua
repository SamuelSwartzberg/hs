--- @type ItemSpecifier
PathInterfaceItemSpecifier = {
  type = "absolute-path",
  properties = {
    getables = {
      ["is-extant-path"] = function(self) return pathExists(self:get("contents")) end,
      ["is-non-extant-path"] = function(self) return not self:get("is-extant-path") end,
      ["is-tilde-absolute-path"] = function(self) return self:get("contents"):find("^~") end,
      ["is-true-absolute-path"] = function(self) return self:get("contents"):find("^/") end,
      ["is-volume"] = function(self) return stringy.startswith(self:get("contents"), "/Volumes/") end,
      ["is-path-by-start"] = function(self)
        return true
      end,
      ["relative-path-from"] = function(self, starting_point)
        return self:get("difference-from-prefix-or-nil", ensureAdfix(starting_point, "/", true, false, "suf"))
      end,
    },
    doThisables = {
      ["create-file"] = function(self, contents) createFile(self:get("contents"), contents) end,
      ["write-file"] = function(self, contents) writeFile(self:get("contents"), contents) end,
      ["create-as-path"] = function(self)
        createPath(self:get("contents"))
      end,
      ["table-to-fs"] = function(self, specifier) 
        if not specifier.payload then 
          -- payload was null or false. Meaning: mode, overwrite doesn't matter
          -- just create the path up to this point, and do nothing else
          createPath(self:get("contents"))
        elseif type(specifier.payload) ~= "table" or isListOrEmptyTable(specifier.payload) then
         --[[  if specifier.mode == "copy" and specifier.overwrite == true then
            copyWithCreatePath(self:get("contents"), specifier.payload)
          elseif specifier.mode == "copy" and specifier.overwrite == false then
            copyWithCreatePathIfDoesntExist(self:get("contents"), specifier.payload)
          elseif specifier.mode == "move" and specifier.overwrite == true then
            moveWithCreatePath(self:get("contents"), specifier.payload)
          elseif specifier.mode == "move" and specifier.overwrite == false then
            moveWithCreatePathIfDoesntExist(self:get("contents"), specifier.payload)
          else ]]if specifier.mode == "write" then
            if self:get("is-non-extant-path") or specifier.overwrite then 
              local filename = self:get("contents")
              if specifier.extension then 
                filename = filename .. "." .. specifier.extension 
              end
              createPathAndFile(filename, "")
              self = CreateStringItem(filename)
            end
            self:doThis("append-rows", specifier.payload)
          elseif specifier.mode == "append" then 
            self:doThis("append-rows", specifier.payload)
          end
        else
          self:doThis("table-to-fs-children-dispatch", specifier)
        end
      end,

    }
  },
  potential_interfaces = ovtable.init({
    { key = "extant-path", value = CreateExtantPathItem },
    { key = "non-extant-path", value = CreateNonExtantPathItem },
    { key = "tilde-absolute-path", value = CreateTildeAbsolutePathItem },
    { key = "true-absolute-path", value = CreateTrueAbsolutePathItem },
    { key = "volume", value = CreateVolumeItem },
    { key = "path-by-start", value = CreatePathByStartItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateAbsolutePathItem = bindArg(NewDynamicContentsComponentInterface, PathInterfaceItemSpecifier)
