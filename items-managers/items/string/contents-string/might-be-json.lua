--- @type ItemSpecifier
MightBeJsonItemSpecifier = {
  type = "might-be-json",
  properties = {
    getables = {
      ["parse-as-json"] = function(self)
        return json.decode(self:get("c"))
      end,
    }
  },
  
 

}

--- @type BoundNewDynamicContentsComponentInterface
CreateMightBeJsonItem = bindArg(NewDynamicContentsComponentInterface, MightBeJsonItemSpecifier)