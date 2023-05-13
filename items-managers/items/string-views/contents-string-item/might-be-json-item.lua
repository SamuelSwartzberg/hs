--- @type ItemSpecifier
MightBeJsonItemSpecifier = {
  type = "might-be-json",
  properties = {
    getables = {
      ["parse-as-json"] = function(self)
        return json.decode(self:get("contents"))
      end,
    }
  },
  
 

}

--- @type BoundNewDynamicContentsComponentInterface
CreateMightBeJsonItem = bindArg(NewDynamicContentsComponentInterface, MightBeJsonItemSpecifier)