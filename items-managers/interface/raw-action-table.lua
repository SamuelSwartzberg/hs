--- @class CopySpecifier
--- @field key string
--- @field description string
--- @field emoji_icon string
--- @field args any
--- @field check? boolean

--- @param specifiers CopySpecifier[]
--- @return action_table
function getChooseItemTable(specifiers)
  local action_table = {}

  for _, specifier in ipairs(specifiers) do
    if specifier.check then 
      specifier.condition = function(item)
        return item:get(specifier.key, specifier.args) ~= nil
      end
    end

    action_table[#action_table + 1] =  {
      text = string.format("%s%s %s%s.", "👉", specifier.emoji_icon, "c", specifier.description),
      key = "choose-action-on-str-item-result-of-get",
      condition = specifier.condition,
      args = {
        key = specifier.key,
        args = specifier.args
      }
    }
  end
  return action_table
end

--- @alias search_engine_specifier {name: string, emoji_icon: string}[]

--- @param search_engines search_engine_specifier
--- @return action_table
function getSearchEngineActionTable(search_engines)
  local res = {}
  for _, search_engine in ipairs(search_engines) do
    res[#res + 1] = {
      text = string.format("%s🔎 s%s.", search_engine.emoji_icon, getShortForm(search_engine.name)),
      key = "search-with",
      args = search_engine.name
    }
  end
  return res
end