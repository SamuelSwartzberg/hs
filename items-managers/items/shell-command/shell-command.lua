--- @type ItemSpecifier
ShellCommandSpecifier = {
  type = "shell-command",
  properties = {
    getables = {
      ["is-libreoffice"] = function(self)
        return self:get("contents") == "libreoffice"
      end,
      ["is-pandoc"] = function(self)
        return self:get("contents") == "pandoc"
      end,
      ["is-khal"] = function(self)
        return self:get("contents") == "khal"
      end,
      ["is-upkg"] = function(self)
        return self:get("contents") == "upkg"
      end,
    },
    doThisables = {
      
    }
  },
  potential_interfaces = ovtable.init({
    { key = "khal", value = CreateKhalCommand },
    { key = "libreoffice", value = CreateLibreofficeCommand },
    { key = "pandoc", value = CreatePandocCommand },
    { key = "upkg", value = CreateUpkgCommand },
  })
}

--- @type BoundRootInitializeInterface
function CreateShellCommand(command)
  return RootInitializeInterface(ShellCommandSpecifier, command)
end

