-- Test case 1: mods and key present
assertMessage(shortcutToString({"cmd", "shift"}, "N"), "⌘⇧ N")

-- Test case 2: only mods present
assertMessage(shortcutToString({"ctrl", "alt", "cmd"}, ""), "⌃⌥⌘ ")

-- Test case 3: only key present
assertMessage(shortcutToString({}, "space"), "space")

-- Test case 4: no mods or key present
assertMessage(shortcutToString({}, ""), "")