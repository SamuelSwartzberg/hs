--- @param mods string[]
--- @param key string
--- @return string | nil
function shortcutToString(mods, key)
  return stringx.join(" ", {stringx.join("", map(map(mods, tblmap.normalize.mod), tblmap.mod_symbolmap)), key})
end