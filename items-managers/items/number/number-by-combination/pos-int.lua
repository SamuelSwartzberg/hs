PosIntSpecifier = {
  type = "pos-int",
  properties = {
    getables = {
      ["to-base"] = function(self, base)
        return string.format("%" .. base, self:get("c"))
      end,
      ["to-unicode-codepoint"] = function(self)
        return string.format("U+%x", self:get("c"))
      end,
      ["codepoint-to-unicode-prop-table"] = function(self)
        return dc(transf.pos_int.unicode_prop_table_from_unicde_codepoint(self:get("c")))
      end,
      ["utf8-to-unicode-prop-table"] = function(self)
        return dc(transf.pos_int.unicode_prop_table_from_utf8(self:get("c")))
      end,
    },
    doThisables = {
      
    }
  },
  
  action_table = {

  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePosInt = bindArg(RootInitializeInterface, PosIntSpecifier)