--- @type ItemSpecifier
MenvDirItemSpecifier = {
  type = "menv-dir",
  properties = {
    getables = {
      ["all-env-vars"] = function(self)
        return self:get("descendant-file-only-string-item-array"):get("filter-to-array-of-non-dotfiles"):get("map-to-new-array", function(item)
          return item:get("to-env-map")
        end):get("flatten-to-single-table"):get("to-env-file-string")
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