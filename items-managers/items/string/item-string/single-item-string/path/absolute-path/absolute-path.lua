--- @type ItemSpecifier
PathInterfaceItemSpecifier = {
  type = "absolute-path",
  properties = {
    getables = {
      ["is-tilde-absolute-path"] = function(self) return self:get("contents"):find("^~") end,
      ["is-true-absolute-path"] = function(self) return self:get("contents"):find("^/") end,
      ["is-extant-path"] = function(self) return testPath(self:get("contents")) end,
      ["is-non-extant-path"] = function(self) return not self:get("is-extant-path") end,
      ["is-volume"] = function(self) return stringy.startswith(self:get("contents"), "/Volumes/") end,
      ["is-path-by-start"] = returnTrue,
      ["relative-path-from"] = function(self, starting_point)
        starting_point = starting_point or env.HOME
        return self:get("difference-from-prefix-or-nil", ensureAdfix(starting_point, "/", true, false, "suf"))
      end,
      ["local-http-server-url"] = function(self)
        return env.FS_HTTP_SERVER .. self:get("completely-resolved-path")
      end,
      ["file-url"] = function (self)
        return "file://" .. self:get("completely-resolved-path")
      end,
    },
    doThisables = {
      ["create-file"] = function(self, contents) writeFile(self:get("contents"), contents, "not-exists") end,
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
            srctgt("copy", self:get("contents"), specifier.payload)
          elseif specifier.mode == "copy" and specifier.overwrite == false then
            srctgt("copy", self:get("contents"), specifier.payload, "not-exists")
          elseif specifier.mode == "move" and specifier.overwrite == true then
            srctgt("move", (self:get("contents"), specifier.payload)
          elseif specifier.mode == "move" and specifier.overwrite == false then
            srctgt("move", IfDoesntExist(self:get("contents"), specifier.payload)
          else ]]if specifier.mode == "write" then
            if self:get("is-non-extant-path") or specifier.overwrite then 
              local filename = self:get("completely-resolved-path")
              if specifier.extension then 
                filename = filename .. "." .. specifier.extension 
              end
              writeFile(filename, "", "not-exists")
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
    -- these two must come first, since checking later potential_interfaces depends on them
    { key = "tilde-absolute-path", value = CreateTildeAbsolutePathItem },
    { key = "true-absolute-path", value = CreateTrueAbsolutePathItem },
    -- other potential_interfaces
    { key = "extant-path", value = CreateExtantPathItem },
    { key = "non-extant-path", value = CreateNonExtantPathItem },
    { key = "volume", value = CreateVolumeItem },
    { key = "path-by-start", value = CreatePathByStartItem },
  }),
  action_table = concat(
    {

    },
    getChooseItemTable({
      {
        description = "httpsrvurl",
        emoji_icon = "💻🌐🏠🔗",
        key = "local-http-server-url",
      },{
        description = "flurl",
        emoji_icon = "📄🔗",
        key = "file-url",
      }
    })
  )
}

--- @type BoundNewDynamicContentsComponentInterface
CreateAbsolutePathItem = bindArg(NewDynamicContentsComponentInterface, PathInterfaceItemSpecifier)
