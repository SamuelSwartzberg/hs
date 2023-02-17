NumberBySignSpecifier = {
  type = "number-by-sign",
  properties = {
    getables = {
      ["is-pos"] = function(self)
        return self:get("contents") > 0
      end,
      ["is-neg"] = function(self)
        return self:get("contents") < 0
      end,
      ["is-zero"] = function(self)
        return self:get("contents") == 0
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