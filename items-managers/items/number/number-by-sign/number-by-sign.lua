NumberBySignSpecifier = {
  type = "number-by-sign",
  properties = {
    getables = {
      ["is-pos"] = function(self)
        return is.number.pos(self:get("contents"))
      end,
      ["is-neg"] = function(self)
        return is.number.neg(self:get("contents"))
      end,
      ["is-zero"] = function(self)
        return is.number.zero(self:get("contents"))
      end,
    },
    doThisables = {
     
    }
  },
  potential_interfaces = ovtable.init({
    { key = "pos", value = CreatePos },
    { key = "neg", value = CreateNeg },
    { key = "zero", value = CreateZero },
  }),
  action_table = {

  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateNumberBySign = bindArg(NewDynamicContentsComponentInterface, NumberBySignSpecifier)