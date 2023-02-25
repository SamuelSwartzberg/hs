-- word means \w+

--- @type ItemSpecifier
WordItemSpecifier = {
  type = "word-item",
  properties = {
    doThisables = {},
    getables = {
      ["evaluated-as-shell-var"] = function(self)
        return run({
          "echo",
          "-n",
          "$" .. self:get("contents")
        })
      end,
      ["is-lowercase-word"] = function(self)
        return not eutf8.find(self:get("contents"), "[^%l_]")
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "lowercase-word", value = CreateLowercaseWordItem },
  }),
  action_table = getChooseItemTable({
    {
      description = "evshv",
      emoji_icon = "💰🛄",
      key = "evaluated-as-shell-var"
    },
  })

}

--- @type BoundNewDynamicContentsComponentInterface
CreateWordItem = bindArg(NewDynamicContentsComponentInterface, WordItemSpecifier)