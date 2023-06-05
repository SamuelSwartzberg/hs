

--- @type ItemSpecifier
ExecutableCodeFileItemSpecifier = {
  type = "executable-code-file",
  properties = {
    getables = {
      ["is-shellscript-file"] = function(self)
        return testPath(self:get("contents"), {
          contents = { r = "^#!.*?(?:ba|z|fi|da|k|t?c)sh\\s+" }
        }) or is.path.usable_as_filetype(self:get("contents"), "shell-script")
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