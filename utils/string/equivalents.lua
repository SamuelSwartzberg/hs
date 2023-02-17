CharReadableEquivalentMap = {
  ["\t"] = "tab",
  ["\n"] = "newline",
  [","] = "comma",
  [";"] = "semicolon",
  ["."] = "period",
  [":"] = "colon",
  ["!"] = "exclamation mark",
  ["?"] = "question mark",
  ["("] = "left parenthesis",
  [")"] = "right parenthesis",
  ["["] = "left bracket",
  ["]"] = "right bracket",
  ["{"] = "left brace",
  ["}"] = "right brace",
  ["'"] = "single quote",
  ['"'] = "double quote",
  ["*"] = "asterisk",
  ["-"] = "minus",
  ["_"] = "underscore",
  ["="] = "equals",
  ["+"] = "plus",
  ["<"] = "less than",
  [">"] = "greater than",
  ["/"] = "slash",
  ["\\"] = "backslash",
  ["|"] = "vertical bar",
  ["~"] = "tilde",
  ["`"] = "backtick",
  ["@"] = "at sign",
  ["#"] = "pound sign",
  ["$"] = "dollar sign",
  ["%"] = "percent sign",
  ["^"] = "caret",
  ["&"] = "ampersand",
  [" "] = "space",
}

MulticharReadableEquivalentMap = {
  [" = "] = "spaced equals",
  [": "] = "right-spaced colon",
  ["%s+"] = "whitespace"
}

StringReadableEquivalentMap = mergeAssocArrRecursive(
  CharReadableEquivalentMap,
  MulticharReadableEquivalentMap
)