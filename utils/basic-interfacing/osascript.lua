--- @param lang? "js" | "as"
--- @param snippet? string
--- @return any
function getViaOSA(lang, snippet)
  local getter 
  lang = lang or "js"
  if lang == "js" then
    getter = hs.osascript.javascript
  elseif lang == "as" then
    getter = hs.osascript.applescript
  else
    error("Invalid language")
  end
  local succ, parsed_res, raw_res = getter(snippet)
  if succ then
    return parsed_res
  else
    return nil
  end
end