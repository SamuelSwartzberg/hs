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