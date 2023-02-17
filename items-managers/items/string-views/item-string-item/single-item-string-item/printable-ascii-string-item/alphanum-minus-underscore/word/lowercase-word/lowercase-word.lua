--- @type ItemSpecifier
LowercaseWordItemSpecifier = {
  type = "lowercase-word-item",
  properties = {
    getables = {
      ["is-pass-name"] = function(self)
        return valuesContain(
          memoized.getLeavesWithoutExtensionInPath(env.MPASS, true, false, true),
          self:get("contents")
        )
      end,
    },
    doThisables = {
      ["add-as-pass-name"] = function(self, password)
        CreateShellCommand("pass"):doThis("add-password", {name = self:get("contents"), password = password})
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
