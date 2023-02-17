assertMessage(
  escapeCharacter("Veni. Vidi. Vici.", ".", "\\"),
  "Veni\\. Vidi\\. Vici\\."
)

assertMessage(
  escapeCharacter("Veni. Vidi. Vici.", "."),
  "Veni\\. Vidi\\. Vici\\."
)

assertMessage(
  escapeCharacter("Veni. Vidi. Vici.", "!"),
  "Veni. Vidi. Vici."
)

assertMessage(
  escapeCharacters(
    "{ key = function () return true end }",
    { "{", "}", "(", ")", "?" }
  ),
  "\\{ key = function \\(\\) return true end \\}"
)

assertMessage(
  escapeCharacters(
    "(({{[[]]}}))",
    { "(", "[", "}" },
    "aaa"
  ),
  "aaa(aaa({{aaa[aaa[]]aaa}aaa}))"
)

assertMessage(
  escapeLuaMetacharacter("a"),
  "a"
)

assertMessage(
  escapeLuaMetacharacter("."),
  "%."
)

assertMessage(
  escapeAllLuaMetacharacters("a.b"),
  "a%.b"
)

assertMessage(
  escapeAllLuaMetacharacters("^[^a-n]+%.%.\\$"),
  "%^%[%^a%-n%]%+%%%.%%%.\\%$"
)

assertMessage(
  escapeGeneralRegex("a.b"),
  "a\\.b"
)

assertMessage(
  escapeGeneralRegex("^[^a-n]+%.%.\\$"),
  "\\^\\[\\^a\\-n\\]\\+%\\.%\\.\\\\\\$"
)