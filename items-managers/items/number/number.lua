NumberSpecifier = {
  type = "number",
  properties = {
    getables = {
      ["is-number-by-sign"] = function() return true end,
      ["is-number-by-number-set"] = function() return true end,
      ["is-number-by-combination"] = function() return true end,
      ["to-date-obj-item"] = function(self, adjustment_factor)
        adjustment_factor = adjustment_factor or 1
        return CreateDate(date(self:get("contents") / adjustment_factor):tolocal())
      end
    },
    doThisables = {
     
    }
  },
  potential_interfaces = ovtable.init({
    { key = "number-by-sign", value = CreateNumberBySign },
    { key = "number-by-number-set", value = CreateNumberByNumberSet },
    { key = "number-by-combination", value = CreateNumberByCombination },
    
  }),
  action_table = {
    {
      text = "👉📅 cdt.",
      key = "choose-action-on-result-of-get",
      args = { key = "to-date-obj-item"}
    },{
      text = "👉📅 cdtms.",
      key = "choose-action-on-result-of-get",
      args = { key = "to-date-obj-item", args = 1000}
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateNumber = bindArg(RootInitializeInterface, NumberSpecifier)