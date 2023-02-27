--- @type ItemSpecifier
LowercaseWordItemSpecifier = {
  type = "lowercase-word-item",
  properties = {
    getables = {
      ["is-pass-name"] = function(self)
        return valuesContain(
          memoize(getAllInPath)({
            path = env.MPASS,
            recursion = true,
            include_dirs = false,
            slice_results = "-2:-2",
            slice_results_opts = { ext_sep = true },
          }),
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
