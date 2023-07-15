--- @type ItemSpecifier
LowercaseWordItemSpecifier = {
  type = "lowercase-word",
  properties = {
    doThisables = {
      ["add-as-pass-name"] = function(self, password)
        dothis.alphanum_minus_underscore.add_passw_pass_item_name(password, self:get("c"))
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "pass-name", value = CreatePassNameItem },
  }),
  action_table = {
    {
      text = "📌🔑 addpssnm.",
      key = "do-interactive",
      args = {
        key = "add-as-pass-name",
        thing = "pass entry password"
      }
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateLowercaseWordItem = bindArg(NewDynamicContentsComponentInterface, LowercaseWordItemSpecifier)
