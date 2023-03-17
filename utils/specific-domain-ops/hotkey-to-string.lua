--- mods + key to the kind of string you'd see in a hotkey hint in a macos menu
--- @param mods string[]
--- @param key string
--- @return string | nil
function shortcutToString(mods, key)
  return stringx.join(" ", {stringx.join("", map(mods, tblmap.mod.symbol)), key})
end