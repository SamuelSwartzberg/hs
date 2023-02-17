--- @type ItemSpecifier
ShellCommandSpecifier = {
  type = "shell-command",
  properties = {
    getables = {
      ["is-khard"] = function(self)
        return self:get("contents") == "khard"
      end,
      ["is-pass"] = function(self)
        return self:get("contents") == "pass"
      end,
      ["is-mullvad"] = function(self)
        return self:get("contents") == "mullvad"
      end,
      ["is-syn"] = function(self)
        return self:get("contents") == "syn"
      end,
      ["is-synonyms"] = function(self)
        return self:get("contents") == "synonyms"
      end,
      ["is-uni"] = function(self)
        return self:get("contents") == "uni"
      end,
      ["is-libreoffice"] = function(self)
        return self:get("contents") == "libreoffice"
      end,
      ["is-pandoc"] = function(self)
        return self:get("contents") == "pandoc"
      end,
      ["is-khal"] = function(self)
        return self:get("contents") == "khal"
      end,
    },
    doThisables = {
      
    }
  },
  potential_interfaces = ovtable.init({
    { key = "khard", value = CreateKhardCommand },
    { key = "khal", value = CreateKhalCommand },
    { key = "pass", value = CreatePassCommand },
    { key = "mullvad", value = CreateMullvadCommand },
    { key = "syn", value = CreateSynCommand },
    { key = "synonyms", value = CreateSynonymsCommand },
    { key = "uni", value = CreateUniCommand },
    { key = "libreoffice", value = CreateLibreofficeCommand },
    { key = "pandoc", value = CreatePandocCommand },
  })
}

--- @type BoundRootInitializeInterface
function CreateShellCommand(command)
  return RootInitializeInterface(ShellCommandSpecifier, command)
end

