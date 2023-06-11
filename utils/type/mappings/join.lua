join = {
  string = {
    table = {
      with_yaml_metadata = function(str, tbl)
        if not str then return transf.table.yaml_metadata(tbl) end
        if not tbl then return str end
        if len(tbl) == 0 then return str end
        local stripped_str = stringy.strip(str)
        local final_metadata, final_contents
        if stringy.startswith(stripped_str, "---") then
          -- splice in the metadata
          local parts = filter(stringy.split(str, "---"), true) -- this should now have the existing metadata as [1], and the content as [2] ... [n]
          local extant_metadata = table.remove(parts, 1)
          final_metadata = extant_metadata .. "\n" .. yamlDump(tbl)
          final_contents = concat(parts, "---")
        else
          final_metadata = yamlDump(tbl)
          final_contents = str
        end
        return "---\n" .. final_metadata .. "\n---\n" .. final_contents
      end,
      email = function(str, tbl)
        local header = transf.table.email_header(tbl)
        local mail = string.format("%s\n\n%s", header, str)
        return mail
      end
    },
    string = {
      email_header = function(name, val)
        return string.format("%s: %s", transf.word.capitalized(name), le(val))
      end
    }
  },
  modifier_array = {
    key = {
      --- mods + key to the kind of string you'd see in a hotkey hint in a macos menu
      --- @param mods string[]
      --- @param key string
      --- @return string | nil
      shortcut_string = function(mods, key)
        local modstr = stringx.join("", map(mods, tblmap.mod.symbol))
        if modstr == "" then
          return key
        else
          return modstr .. " " .. key
        end
      end
    }
  },
}