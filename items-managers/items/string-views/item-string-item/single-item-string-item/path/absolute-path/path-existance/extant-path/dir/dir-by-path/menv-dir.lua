--- @type ItemSpecifier
MenvDirItemSpecifier = {
  type = "menv-dir",
  properties = {
    getables = {
      ["all-env-vars"] = function(self)
        return self:get("descendant-file-only-string-item-array"):get("filter-to-array-of-non-dotfiles"):get("to-single-env-map"):get("to-env-file-string")
      end,
      ["refresh-env-task"] = function(self)
        return {
          fn = function()
            self:doThis("write-env-file")
            self:doThis("source-env")
          end,
          interval = 300,
        }
      end,
      
    },
    doThisables = {
      ["write-env-file"] = function(self)
        local envfile_string_item = CreateStringItem(env.ENVFILE)
        envfile_string_item:doThis("overwrite-file-contents", self:get("all-env-vars"))
        if envfile_string_item:get("has-warnings") then
          error("Envfile had errors: \n" .. envfile_string_item:get("lint-simple-text", "warning"))
        end
      end,
      ["update-env-source-file"] = function(self, specifier)
        self:get("descendant-ending-with-to-string-item", specifier.name .. ".yaml"):doThis("merge-file-contents-with-lua-table", specifier.payload)
      end,
      ["update-env-source-file-and-write-env-file"] = function(self, specifier)
        self:doThis("update-env-source-file", specifier)
        self:doThis("write-env-file")
      end,
      ["source-env"] = function()
        env = getEnvAsTable()
      end,
      ["update-env-source-file-write-and-re-source-env"] = function(self, specifier)
        self:doThis("update-env-source-file-and-write-env-file", specifier)
        self:doThis("source-env")
      end,
        
    }
  },
  action_table = {
    {
      text = "📝💰🛄📄 wrtenvfl.",
      key = "write-env-file",
    },{
      text = "🎣💰🛄📄 srcenvfl.",
      key = "source-env",
    }
  }
  
}


--- @type BoundNewDynamicContentsComponentInterface
CreateMenvDirItem = bindArg(NewDynamicContentsComponentInterface, MenvDirItemSpecifier)