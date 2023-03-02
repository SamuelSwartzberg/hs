

--- @param field string
--- @return string
function escapeField(field)
  local escaped_quotes = eutf8.gsub(field, '"', '""')
  local escaped_newlines = eutf8.gsub(escaped_quotes, '\n', '\\n') -- not technically necessary for CSV, but so many implementations don't handle newlines properly that it's worth it
  return '"' .. escaped_newlines  .. '"'
end

--- @param mods string[]
--- @param key string
--- @return string | nil
function shortcutToString(mods, key)
  local modifier_str = stringx.join("", modsToSymbols(mods))
  if key ~= "" then
    if modifier_str ~= "" then
      return modifier_str .. " " .. key
    else
      return key
    end
  else
    return nil
  end
end

--- @param str string
--- @param splitter string
--- @param prefix string
--- @return string
function prependAllWith(str, splitter, prefix)
  local parts 
  if #splitter == 1 then
    parts = stringy.split(str, splitter)
  else
    parts = stringx.split(str, splitter)
  end
  local prefixed_parts = map(
    parts,
    function (value)
      return prefix .. value
    end
  )
  return stringx.join(splitter, prefixed_parts)
end

--- @param str string
--- @param prefix
function quoteLines(str, prefix)
  local body = stringy.strip(str)
  local lines = stringx.splitlines(body)
  local newlines = {}
  for i, line in ipairs(lines) do
    if stringy.startswith(line, prefix) then
      table.insert(newlines, prefix .. line)
    else
      table.insert(newlines, prefix .. " " .. line)
    end
  end
  return stringx.join("\n", newlines)
end

 