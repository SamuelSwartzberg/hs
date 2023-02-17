

--- @type ItemSpecifier
ShellscriptFileItemSpecifier = {
  type = "shellscript-file",
  properties = {
    getables = {
      ["lint-json"] = function(self, severity)
        local res = getOutputTask({
          "shellcheck",
          "--format=json",
          "--severity=" .. severity,
          { value = self:get("contents"), type = "quoted" },
        })
        return res
      end,
      ["lint-simple-text"] = function(self, severity)
        local res = getOutputTask({
          "shellcheck",
          "--format=gcc",
          "--severity=" .. severity,
          { value = self:get("contents"), type = "quoted" },
        })
        return res
      end,
    },
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreateShellscriptFileItem = bindArg(NewDynamicContentsComponentInterface, ShellscriptFileItemSpecifier)