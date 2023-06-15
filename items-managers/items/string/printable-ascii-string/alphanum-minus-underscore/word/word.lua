-- word means \w+

--- @type ItemSpecifier
WordItemSpecifier = {
  type = "word",
  properties = {
    doThisables = {},
    getables = {
      ["evaluated-as-shell-var"] = function(self)
        return run({
          "echo",
          "-n",
          "$" .. self:get("c")
        })
      end,
      ["is-lowercase-word"] = function(self)
        return not eutf8.find(self:get("c"), "[^%l_]")
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "lowercase-word", value = CreateLowercaseWordItem },
  }),
  action_table = getChooseItemTable({
    {
      d = "evshv",
      i = "💰🛄",
      key = "evaluated-as-shell-var"
    },
  })

}

--- @type BoundNewDynamicContentsComponentInterface
CreateWordItem = bindArg(NewDynamicContentsComponentInterface, WordItemSpecifier)