

--- @type ItemSpecifier
ExecutableCodeFileItemSpecifier = {
  type = "executable-code-file",
  properties = {
    getables = {
      ["is-shellscript-file"] = bc(is.file.shellscript_file)
    },
  },
  ({
    { key = "shellscript-file", value = CreateShellscriptFileItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateExecutableCodeFileItem = bindArg(NewDynamicContentsComponentInterface, ExecutableCodeFileItemSpecifier)