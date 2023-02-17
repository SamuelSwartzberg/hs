

--- @type ItemSpecifier
ExecutableCodeFileItemSpecifier = {
  type = "executable-code-file",
  properties = {
    getables = {
      ["is-shellscript-file"] = function(self)
        return isShellShebangLine(self:get("first-line-of-file-contents")) or isUsableAsFiletype(self:get("contents"), "shell-script")
      end,
      ["has-errors"] = function(self)
        return stringy.strip(self:get("lint-simple-text", "error")) ~= ""
      end,
      ["has-warnings"] = function (self)
        return stringy.strip(self:get("lint-simple-text", "warning")) ~= ""
      end
    },
  },
  potential_interfaces = ovtable.init({
    { key = "shellscript-file", value = CreateShellscriptFileItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateExecutableCodeFileItem = bindArg(NewDynamicContentsComponentInterface, ExecutableCodeFileItemSpecifier)