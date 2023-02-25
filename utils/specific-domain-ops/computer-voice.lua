
local lang_voice_map = {
  ["en"] = "Ava",
  ["ja"] = "Kyoko",
}

---@param text string
---@param lang "en" | "ja"
function say(text, lang)
  return runHsTask({"say", "-v", lang_voice_map[lang], {value = text, type = "quoted"}})
end