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
          interval = "*/5 * * * *",
        }
      end,
      
    },
    doThisables = {
      ["write-env-file"] = function(self)
        local envfile_string_item = st(env.ENVFILE)
        envfile_string_item:doThis("overwrite-file-contents", self:get("all-env-vars"))
        if envfile_string_item:get("has-warnings") then
          error("Envfile had errors: \n" .. envfile_string_item:get("lint-simple-text", "warning"))
        end
      end,
      ["source-env"] = function()
        env = getEnvAsTable()
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