--- @type ItemSpecifier
LowercaseWordItemSpecifier = {
  type = "lowercase-word",
  properties = {
    getables = {
      ["is-pass-name"] = function(self)
        return find(
          memoize(itemsInPath, refstore.params.memoize.opts.stringify_json)({
            path = env.MPASS,
            recursion = true,
            include_dirs = false,
            slice_results = "-2:-2",
            slice_results_opts = { ext_sep = true },
          }),
          {_exactly = self:get("c")}
        )
      end,
    },
    doThisables = {
      ["add-as-pass-name"] = function(self, password)
        dothis.pass.add_password(password, self:get("c"))
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
