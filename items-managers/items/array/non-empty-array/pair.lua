
PairSpecifier = {
  type = "pair",
  properties = {
    getables = {
      ["pair-key"] = function(self) return self:get("c")[1] end,
      ["pair-value"] = function(self) return self:get("c")[2] end,
    },
    doThisables = {
    },
  },
  action_table = {}
  
  }

--- @type BoundNewDynamicContentsComponentInterface
CreatePair = bindArg(NewDynamicContentsComponentInterface, PairSpecifier)