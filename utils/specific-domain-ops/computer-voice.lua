
local lang_voice_map = {
  ["en"] = "Ava",
  ["ja"] = "Kyoko",
}

---@param text string
---@param lang "en" | "ja"
function say(text, lang)
  return run({"say", "-v", lang_voice_map[lang], {value = text, type = "quoted"}}, true)
end