--- prevents hs.eventtap.keyStrokes from chewing up `\n`
--- @param str string
--- @return nil
function pasteMultilineString(str)
  local lines = stringy.split(str, "\n")
  local is_first_line = true
  for _, line in iprs(lines) do
    if is_first_line then
      is_first_line = false
    else
      hs.eventtap.keyStroke({}, "return")
    end
    hs.eventtap.keyStrokes(line)
  end
end