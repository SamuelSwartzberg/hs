NumberSpecifier = {
  type = "number",
  properties = {
    getables = {
      ["is-number-by-sign"] = function() return true end,
      ["is-number-by-number-set"] = function() return true end,
      ["is-number-by-combination"] = function() return true end,
      ["to-date-obj-item"] = function(self)
        return CreateDate(date(self:get("contents")))
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
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateNumber = bindArg(RootInitializeInterface, NumberSpecifier)